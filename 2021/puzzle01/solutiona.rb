#!/usr/local/bin/ruby

require '../solution2021'

class Solution < Solution2021
  private

  # override
  def additional_setup
    @answer = 0
  end

  def process_input
    @answer = (1..(@input.size - 1)).map { |n| @input[n].to_i > @input[n - 1].to_i ? 1 : 0 }.sum
  end
end

Solution.new.run! testmode: false
# 1226
