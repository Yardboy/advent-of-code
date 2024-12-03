#!/usr/local/bin/ruby

require '../solution2024.rb'

class Solution < Solution2024
  private

  # override
  def additional_setup
    @answer = 0
    split_input
    inputs_are_integers
  end

  def process_input
    @input.each do |levels|
      if ascending_or_descending?(levels) && within_limits?(levels)
        @answer += 1
      end
    end
  end

  def ascending_or_descending?(levels)
    levels.sort == levels || levels.sort.reverse == levels
  end

  def within_limits?(levels)
    levels[..-2].zip(levels[1..]).all? { |a, b| (a - b).abs >= 1 && (a-b).abs <= 3 }
  end
end

Solution.new.run! testmode: false
# 356
