#!/usr/local/bin/ruby

require '../solution2019'

class Solution < Solution2019
  private

  # override
  def additional_setup
    @answer = 0
  end

  def process_input
    @input.each do |mass|
      @answer += (mass.to_i / 3.0).floor - 2
    end
  end
end

Solution.new.run! # true
