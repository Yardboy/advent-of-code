#!/usr/local/bin/ruby

require '../solution2019'
require '../intcode'

class Solution < Solution2019
  private

  def process_input
    (0..99).each do |noun|
      (0..99).each do |verb|
        update_input(noun, verb)
        run_program(noun, verb)
        break if @answer
      end
      break if @answer
    end
  end

  def run_program(noun, verb)
    computer = Intcode::Computer.new(@input.dup)
    computer.run!(nil, @test)
    @answer = 100 * noun + verb if computer.input.first == 19_690_720
  end

  def update_input(noun, verb)
    @input[1] = noun
    @input[2] = verb
  end

  # override
  def read_input
    super
    @input = @input.first.split(',').map(&:to_i)
  end
end

Solution.new.run! # true
