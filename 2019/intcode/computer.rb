module Intcode
  class Computer
    include Opcodes
    include Modes
    include Memory

    attr_reader :position, :input

    def initialize(input)
      @input = input.split(',').map(&:to_i)
    end

    # override
    def run!(user_inputs, test = false)
      @user_inputs = Array(user_inputs)
      @test = test
      initial_setup
      process_input
    end

    def restart!(user_inputs)
      @user_inputs += Array(user_inputs)
      @state = 'running'
      process_input
    end

    %w[running waiting done].each do |mthd|
      define_method "#{mthd}?" do
        @state == mthd
      end
    end

    private

    def initial_setup
      @answer = []
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
  end
end
