#!/usr/local/bin/ruby

require '../solution2024.rb'

class Solution < Solution2024
  private

  # override
  def additional_setup
    @answer = 0
    split_input
    inputs_are_integers
    @lista = @input.map(&:first).sort
    @listb = @input.map(&:last).sort
  end

  def process_input
    @lista.each do |a|
      similarity = @listb.select { |b| b == a }.size
      @answer += (a * similarity)
    end
  end
end

Solution.new.run! testmode: false
# 23082277
