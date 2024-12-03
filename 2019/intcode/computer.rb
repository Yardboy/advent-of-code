module Intcode
  class Computer
    include Opcodes
    include Modes
    include Memory

    attr_reader :position, :input, :outputs

    def initialize(input)
      @input = input.split(',').map(&:to_i)
      @user_inputs = []
    end

    # override
    def run!(user_inputs, test = false)
      @user_inputs += Array(user_inputs)
      if waiting?
        @state = 'running'
      else
        @test = test
        initial_setup
      end
      process_input
    end

    def clear_output!
      @outputs = []
    end

    %w[running waiting done].each do |mthd|
      define_method "#{mthd}?" do
        @state == mthd
      end
    end

    private

    def initial_setup
      @state = 'running'
      @position = 0
      @relative_base = 0
      @debug = false
      @outputs = []
    end

    def process_input
      while running?
        puts "Instruction: #{opcode}" if @debug
        send "opcode#{opcode_instruction}"
      end
      @outputs
    end

    def opcode
      # opcodes of 3 default to immediate mode
      # all others default to position mode
      @input[@position] == 3 ? '00103' : format('%05i', @input[@position])
    end

    def opcode_instruction
      opcode[-2..].to_i
    end

    def opcode_modes
      opcode[0..-3].chars.map(&:to_i).reverse
    end

    def move_pointer(value)
      @position += value
    end

    def user_input
      @user_inputs.shift
    end
  end
end
