class KnuthSolver
  def initialize(colors, code_length)
    @colors = colors
    @code_length = code_length
    @possibilities = @colors.repeated_permutation(@code_length).to_a
    @last_guess = nil
    @last_feedback = nil
  end

  # Generates the next guess using minimax strategy
  def next_guess
    if @last_guess.nil?
      @last_guess = [@colors[0], @colors[0], @colors[1], @colors[1]]
    else
      filter_possibilities
      @last_guess = minimax_guess
    end
    @last_guess
  end

  # Updates feedback for the last guess
  def provide_feedback(guess, feedback)
    @last_guess = guess
    @last_feedback = feedback
  end

  private

  # Filters possibilities based on feedback
  def filter_possibilities
    @possibilities.select! do |possibility|
      evaluate_guess(possibility, @last_guess) == @last_feedback
    end
  end

  # Computes feedback for a given guess and code
  def evaluate_guess(guess, code)
    correct_positions = guess.each_with_index.count { |color, i| color == code[i] }
    correct_colors = common_elements(guess, code) - correct_positions
    [correct_positions, correct_colors]
  end

  # Computes the best next guess using the minimax strategy
  def minimax_guess
    scores = @possibilities.each_with_object({}) do |guess, score_map|
      feedback_counts = Hash.new(0)

      @possibilities.each do |possibility|
        feedback = evaluate_guess(possibility, guess)
        feedback_counts[feedback] += 1
      end

      # Worst-case size of the remaining possibilities
      worst_case = feedback_counts.values.max
      score_map[guess] = worst_case
    end

    # Select the guess with the smallest worst-case score
    scores.min_by { |_, score| score }.first
  end

  # Counts common elements between guess and code
  def common_elements(guess, code)
    freq1 = guess.tally
    freq2 = code.tally
    freq1.sum { |color, count| [count, freq2[color] || 0].min }
  end
end
