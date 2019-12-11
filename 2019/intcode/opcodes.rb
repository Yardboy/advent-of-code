module Intcode
  module Opcodes
    # add and update
    def opcode1
      update_value(value_by_mode(1) + value_by_mode(2), 3)
      move_pointer(4)
    end

    # multiply and update
    def opcode2
      update_value(value_by_mode(1) * value_by_mode(2), 3)
      move_pointer(4)
    end

    # get input
    def opcode3
      value = user_input
      if value.nil?
        @state = 'waiting'
      else
        update_value(value, 1)
        move_pointer(2)
      end
    end

    # output
    def opcode4
      puts "Output:      #{value_by_mode(1)}" if @debug
      @answer << value_by_mode(1)
      move_pointer(2)
    end

    # jump if true
    def opcode5
      if value_by_mode(1).zero?
        move_pointer(3)
      else
        @position = value_by_mode(2)
      end
    end

    # jump if false
    def opcode6
      if value_by_mode(1).zero?
        @position = value_by_mode(2)
      else
        move_pointer(3)
      end
    end

    # update true if less than
    def opcode7
      if value_by_mode(1) < value_by_mode(2)
        update_value(1, 3)
      else
        update_value(0, 3)
      end
      move_pointer(4)
    end

    # update true if equals
    def opcode8
      if value_by_mode(1) == value_by_mode(2)
        update_value(1, 3)
      else
        update_value(0, 3)
      end
      move_pointer(4)
    end

    # update relative base
    def opcode9
      @relative_base += value_by_mode(1)
      move_pointer(2)
    end

    # halt
    def opcode99
      @state = 'done'
    end
  end
end
