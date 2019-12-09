# Used in the following days:
# Day 05a: 12440243
# Day 05b: 15486302
# Day 07a: 51679
# Day 07b: 19539216
# Day 09a: 2465411646
#
require_relative 'intcode/opcodes'
require_relative 'intcode/modes'
require_relative 'intcode/memory'

module Intcode
  class Computer < Solution2019
    include Opcodes
    include Modes
    include Memory

    attr_reader :state, :position

    # override
    def run!(user_inputs, test = false)
      @user_inputs = Array(user_inputs)
      @test = test
      @state = 'running'
      @position = 0
      @relative_base = 0
      @debug = false
      read_input
      process_input
    end

    def restart!(user_inputs)
      @user_inputs += Array(user_inputs)
      @state = 'running'
      process_input
    end

    private

    def process_input
      while @state == 'running'
        puts "Instruction: #{opcode}" if @debug
        send "opcode#{opcode_instruction}"
      end
      @answer
    end

    def opcode
      # opcodes of 3 default to immediate mode
      # all others default to position mode
      @input[@position] == 3 ? '00103' : format('%05i', @input[@position])
    end

    def opcode_instruction
      opcode[-2..-1].to_i
    end

    def opcode_modes
      opcode[0..-3].split('').map(&:to_i).reverse
    end

    def move_pointer(value)
      @position += value
    end

    def user_input
      @user_inputs.shift
    end

    # override
    def read_input
      super
      @input = @input.first.split(',').map(&:to_i)
    end
  end
end
