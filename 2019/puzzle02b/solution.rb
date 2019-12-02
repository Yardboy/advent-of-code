#!/usr/local/bin/ruby

require '../solution2019'

class Solution < Solution2019
  private

  def process_input
    (0..99).each do |noun|
      (0..99).each do |verb|
        update_input(noun, verb)
        run_program
        @answer = 100 * noun + verb if @input[0] == 19_690_720
        break if @answer

        reload
      end
      break if @answer
    end
  end

  def reload
    @input = []
    read_input
  end

  def run_program
    position = 0
    opcode = @input[position]
    while opcode != 99
      value = process_opcode(opcode, position)
      update_value(value, position)
      position += 4
      opcode = @input[position]
    end
  end

  def update_input(noun, verb)
    @input[1] = noun
    @input[2] = verb
  end

  def process_opcode(opcode, position)
    val1 = value_from_position(@input[position + 1])
    val2 = value_from_position(@input[position + 2])
    if opcode == 1
      value = val1 + val2
    elsif opcode == 2
      value = val1 * val2
    else
      raise UnknownActionError
    end
    value
  end

  def value_from_position(position)
    @input[position]
  end

  def update_value(value, position)
    position = @input[position + 3]
    @input[position] = value
  end

  # override
  def read_input
    super
    @input = @input.first.split(',').map(&:to_i)
  end
end

Solution.new.run! # true
