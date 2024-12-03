#!/usr/local/bin/ruby

require '../solution2021'

class Solution < Solution2021
  private

  # override
  def additional_setup
    @input = @input.map { |line| line.chars.map(&:to_i) }
    @tracker = []
    @answer = 0
  end

  def process_input
    @input.each do |digits|
      digits.each_with_index do |digit, index|
        @tracker << 0 unless @tracker[index]
        @tracker[index] += digit.positive? ? 1 : -1
      end
    end

    @answer = gamma.to_i(2) * epsilon.to_i(2)
  end

  def gamma
    @tracker.map { |digit| digit.positive? ? '1' : '0' }.join
  end

  def epsilon
    @tracker.map { |digit| digit.negative? ? '1' : '0' }.join
  end
end

Solution.new.run! testmode: false
# 2035764
