#!/usr/local/bin/ruby

require '../solution2024.rb'

class Solution < Solution2024
  private

  # override
  def additional_setup
    @answer = 0
  end

  def process_input
    @input.each_with_index do |report, index|
      levels = report.split.map(&:to_i)
      if ([levels] + adjusted_levels(levels)).any? { |check_levels|
        ascending_or_descending?(check_levels) && within_limits?(check_levels)
      }
        @answer += 1
      end
    end
  end

  def adjusted_levels(levels)
    0.upto(levels.size - 1).map do |i|
      new_levels = levels.dup
      new_levels.delete_at(i)
      new_levels
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
# 413
