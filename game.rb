# A class containing methods for running the main gameplay loop
# Responsible for loading in a dictionary and determining when the game is won or lost
require_relative 'board'
require_relative 'player'
require 'yaml'
require 'pry-byebug'

class Game
  attr_accessor :secret_word, :player, :revealed_letters, :guessed_letters

  def self.from_yaml(file_name)
    save_file = File.open(file_name, 'r')
    contents = save_file.read
    data = YAML.load contents
    save_file.close
    game = self.new(
      data[:board]
    )
    game.player = data[:player]
    game.secret_word = data[:secret_word]
    game.revealed_letters = data[:revealed_letters]
    game.guessed_letters = data[:guessed_letters]
    game
  end

  def initialize(board)
    @dictionary = File.readlines('google-10000-english-no-swears.txt').map(&:chomp)
    @dictionary.reject! { |word| word.length < 5 || word.length > 12 }
    @secret_word = @dictionary.sample
    @revealed_letters = Array.new(@secret_word.length, '_')
    @board = board
    @player = nil
    @guessed_letters = []
  end

  def save
    yaml_str = YAML.dump ({
      secret_word: @secret_word,
      revealed_letters: @revealed_letters,
      guessed_letters: @guessed_letters,
      board: @board,
      player: @player
    })
    save_file = File.open('save_file.yaml', 'w')
    save_file.puts yaml_str
    save_file.close
  end

  def play
    setup_player if @player.nil?
    until gameover?
      update_display(@guessed_letters)
      player_input = fetch_player_input(@guessed_letters)
      if player_input == 'save'
        save
      elsif @secret_word.include?(player_input)
        update_revealed_letters(player_input)
      else
        @board.hang_the_man
      end
    end
    print_endgame_message
  end

  def setup_player
    system('clear')
    puts 'Welcome to Hangman!'
    @player = Player.new
  end

  def print_endgame_message
    if win?
      puts "#{@player.name} wins, the answer was:"
    else
      @board.render
      puts "#{@player.name} was hanged, the answer was:"
    end
    puts "#{@secret_word}"
  end

  def gameover?
    @board.completed? || win?
  end

  # renders stick figure and displays the currently revealed letters
  def update_display(guessed_letters)
    system('clear')
    @board.render
    puts "\nGuessed letters: #{guessed_letters}"
    puts "\n#{@revealed_letters.join(' ')}"
  end

  # gets a player_input from player and returns the player_input
  def fetch_player_input(guessed_letters)
    player_input = @player.guess_letter
    player_input = @player.guess_letter until valid_input?(player_input) && guessed_letters.none? { |letter| letter == player_input }

    return player_input.downcase if player_input.downcase == 'save'

    guessed_letters << player_input
    player_input
  end

  # takes in a letter and the currently revealed chars
  # reveals all occurences of the guessed letter that are in secret word
  def update_revealed_letters(guess)
    @secret_word.each_char.with_index do |char, idx|
      if guess == char
        @revealed_letters[idx] = char
      end
    end
  end

  def valid_input?(input)
    return true if input.downcase == 'save'
    return false unless input.length == 1

    return true if ('a'..'z').include?(input.downcase)

    false
  end

  def win?
    @revealed_letters.join == @secret_word
  end
end
