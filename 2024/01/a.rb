#!/usr/local/bin/ruby

require '../solution2024.rb'

class Solution < Solution2024
  private

  # override
  def additional_setup
    @answer = 0
    @input = @input.map { |line| line.split.map(&:to_i) }
    @lista = @input.map(&:first).sort
    @listb = @input.map(&:last).sort
  end

  def process_input
    @lista.zip(@listb).each do |a, b|
      @answer += (a - b).abs
    end
  end
end

Solution.new.run! testmode: false
# 2375403