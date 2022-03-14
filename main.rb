require_relative 'game'

print 'Load from last save file? (enter y or n): '
answer = gets.chomp

if %w[y Y].include?(answer)
  begin
    game = Game.from_yaml('save_file.yaml')
    game.play
  rescue => e
    puts 'No save file found'
  end
else
  board = Board.new
  game = Game.new(board)
  game.play
end
