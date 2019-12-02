#!/usr/local/bin/ruby

require '../solution2019'

class Solution < Solution2019
  private

  def process_input
    @answer = 0
    @input.each do |mass|
      @answer += (mass.to_i / 3.0).floor - 2
    end
  end
end

Solution.new.run! # true
