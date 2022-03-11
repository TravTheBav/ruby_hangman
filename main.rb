require_relative 'game'

file = 'google-10000-english-no-swears.txt'
board = Board.new
game = Game.new(file, board)
game.play
