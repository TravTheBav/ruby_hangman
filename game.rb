# A class containing methods for running the main gameplay loop
# Responsible for loading in a dictionary and determining when the game is won or lost
require_relative 'board.rb'
require_relative 'player.rb'
require 'pry-byebug'

class Game
  def initialize(dictionary, board, player)
    @dictionary = File.readlines(dictionary).map(&:chomp)
    @dictionary.reject! { |word| word.length < 5 || word.length > 12 }
    @secret_word = @dictionary.sample 
    @board = board
    @player = player
  end

  def play    
    puts "Welcome to Hangman!"
    revealed_letters = Array.new(@secret_word.length, '_')
    guessed_letters = []
    until gameover?
      update_display(revealed_letters, guessed_letters)
      guess = retrieve_letter(guessed_letters)
      update_revealed_letters(guess, revealed_letters)
    end
  end

  def gameover?
    false
  end

  # renders stick figure and displays the currently revealed letters
  def update_display(revealed_letters, guessed_letters)
    @board.render
    puts "\nGuessed letters: #{guessed_letters}"
    puts "\n#{revealed_letters.join(' ')}"
  end

  # gets a guess from player and returns the guess
  def retrieve_letter(guessed_letters)
    guess = @player.guess_letter
    guess = @player.guess_letter until valid_input?(guess) && guessed_letters.none? { |letter| letter == guess }
    guessed_letters << guess
    guess
  end

  # takes in a letter and the currently revealed chars
  # reveals all occurences of the guessed letter that are in secret word
  def update_revealed_letters(guess, revealed_letters)
    @secret_word.each_char.with_index do |char, idx|
      if guess == char
        revealed_letters[idx] = char
      end
    end
  end

  def valid_input?(input)
    return false unless input.length == 1
    
    if ('a'..'z').include?(input.downcase)
        return true
    end
    false
  end  
end

file = 'google-10000-english-no-swears.txt'
player = Player.new
board = Board.new
game = Game.new(file, board, player)
game.play
