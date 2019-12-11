#!/usr/local/bin/ruby

require '../solution2019'
require '../intcode'

class Solution < Solution2019
  private

  def process_input
    @input = @input.first
    update_input
    computer.run!(nil, @test)
    @answer = computer.input.first
  end

  def update_input
    @input = @input.split(',').map(&:to_i)
    @input[1] = 12
    @input[2] = 2
    @input = @input.join(',')
  end

  def computer
    @computer ||= Intcode::Computer.new(@input)
  end
end

Solution.new.run! # true
