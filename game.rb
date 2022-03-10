# A class containing methods for running the main gameplay loop
# Responsible for loading in a dictionary and determining when the game is won or lost
require_relative 'board.rb'
require_relative 'player.rb'

class Game
  def initialize(dictionary, board)
    @dictionary = File.readlines(dictionary).map { |word| word.chomp }
    @dictionary = @dictionary.reject { |word| word.length < 5 || word.length > 12 }
    @board = board
    @secret_word = @dictionary.sample
  end

  def play
    revealed_chars = Array.new(@secret_word.length, '_').join(' ')
    puts "Welcome to Hangman!"
    @player = Player.new
    until gameover?
      @board.render
      puts "\n#{revealed_chars}"
      guess = @player.guess_letter
    end
  end

  def gameover?
    false
  end

  
end

g = Game.new('google-10000-english-no-swears.txt', Board.new)
g.play
