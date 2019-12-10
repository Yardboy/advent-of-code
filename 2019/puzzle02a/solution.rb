#!/usr/local/bin/ruby

require '../solution2019'
require '../intcode'

class Solution < Solution2019
  private

  def process_input
    update_input
    computer.run!(nil, @test)
    @answer = computer.input.first
  end

  def update_input
    @input[1] = 12
    @input[2] = 2
  end

  def computer
    @computer ||= Intcode::Computer.new(@input)
  end

  # override
  def read_input
    super
    @input = @input.first.split(',').map(&:to_i)
  end
end

Solution.new.run! # true
