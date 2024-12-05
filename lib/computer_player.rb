require_relative 'player'
require_relative 'knuth_solver'

class ComputerPlayer < Player
  attr_reader :solver

  def initialize(colors, code_length)
    super
    @solver = KnuthSolver.new(colors, code_length)
  end

  def guess
    @solver.next_guess
  end
end
