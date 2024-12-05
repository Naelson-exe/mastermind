require_relative 'player'
require_relative 'human_player'
require_relative 'computer_player'

class Mastermind
  COLORS = %w[Green Blue Red Orange Purple Yellow].freeze
  CODE_LENGTH = 4
  MAX_ATTEMPTS = 12

  def initialize
    @mode = nil
    @code = nil
    @attempts = 0
  end

  def play
    puts "Welcome to Mastermind."
    puts "Available colors: #{COLORS.join(', ')}"
    puts "Code length: #{CODE_LENGTH}, Max Attempts: #{MAX_ATTEMPTS}"
    choose_mode
    setup_game
    play_game
  end

  private

  def choose_mode
    puts "Select a mode: (1) for Code Breaker, (2) for Code Setter"
    @mode = gets.chomp.to_i
  end

  def setup_game
    if @mode == 1
      @code = Array.new(CODE_LENGTH) { COLORS.sample }
      @player = HumanPlayer.new(COLORS, CODE_LENGTH)
    elsif @mode == 2
      loop do
        puts "Enter your secret code (e.g., Red Blue Green Yellow):"
        input = gets.chomp.split.map(&:capitalize)
        if valid_code?(input)
          @code = input
          break
        else
          puts "Invalid code! Please ensure it is #{CODE_LENGTH} colors and uses only: #{COLORS.join(', ')}"
        end
      end
      @player = ComputerPlayer.new(COLORS, CODE_LENGTH)
    else
      puts "Invalid choice! Please choose again."
      choose_mode
      setup_game
    end
  end  
  
  def valid_code?(code)
    code.length == CODE_LENGTH && code.all? { |color| COLORS.include?(color) }
  end  

  def play_game
    while @attempts < MAX_ATTEMPTS
      puts "\nAttempt #{@attempts + 1}/#{MAX_ATTEMPTS}"
      guess = @player.guess
      feedback = evaluate_guess(guess)
  
      if guess == @code
        puts @mode == 1 ? "Congratulations, you're a mastermind!" : "The computer has cracked your code!"
        return
      end

      @player.solver.provide_feedback(guess, feedback) if @mode == 2
  
      @attempts += 1
    end
  
    puts "\nGame Over! The code was: #{@code.join(', ')}"
  end   
  
  def evaluate_guess(guess)
    correct_positions = guess.each_with_index.count { |color, i| color == @code[i] }
    correct_colors = common_elements(guess, @code) - correct_positions
    puts "Correctly placed: #{correct_positions}"
    puts "Correct but in wrong position: #{correct_colors}"
    [correct_positions, correct_colors]
  end

  def common_elements(guess, code)
    freq1 = guess.tally
    freq2 = code.tally
    freq1.sum { |color, count| [count, freq2[color] || 0].min }
  end
end
