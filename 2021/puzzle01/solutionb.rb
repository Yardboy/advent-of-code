#!/usr/local/bin/ruby

require '../solution2021'

class Solution < Solution2021
  private

  # override
  def additional_setup
    @input = @input.map(&:to_i)
    @answer = 0
  end

  def process_input
    last = nil
    (0..(@input.size - 3)).each do |n|
      sum = @input[n, 3].sum
      if last
        @answer += (sum > last ? 1 : 0)
      end
      last = sum
    end
  end
end

Solution.new.run! testmode: false
# 1252
