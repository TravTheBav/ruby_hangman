# A class containing methods for running the main gameplay loop
# Responsible for loading in a dictionary and determining when the game is won or lost

class Game
  def initialize(dictionary)
    @dictionary = File.readlines(dictionary).map { |word| word.chomp }
    @dictionary = @dictionary.reject { |word| word.length < 5 || word.length > 12 }
    @secret_word = @dictionary.sample
  end
end
