require_relative 'player'

class HumanPlayer < Player
  def guess
    puts "Enter your guess (e.g., Red Blue Green Yellow):"
    gets.chomp.split.map(&:capitalize)
  end
end
