# class representing a player
# Responsible for getting input from the player

class Player
  def initialize
    @name = new_name
  end  
  
  def new_name
    print 'Enter your name: '
    gets.chomp
  end

  def guess_letter
    print 'Guess a letter: '
    gets.chomp
  end
end