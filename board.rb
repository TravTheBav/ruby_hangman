# A class representing a board in hangman
# Responsible for drawing the stick figure and displaying text on each turn

class Board
  def initialize
    @body_parts = [  
      "_________ ",
      "        | ",
      "        | ",
      "        O ",
      "       /|\\ ",
      "       / \\ ",
    ]
    @current_row = 0
  end

  def render
    @body_parts.each_with_index do |part, idx|
      break if idx == @current_row

      puts part
    end
  end

  def hang_the_man
    @current_row += 1
  end

  def completed?
    @current_row == @body_parts.length
  end
end
