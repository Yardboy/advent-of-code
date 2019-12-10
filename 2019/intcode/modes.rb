module Intcode
  class UnknownOpcodeModeError < StandardError; end

  module Modes
    def value_by_mode(parm)
      case opcode_modes[parm - 1]
      when 0
        position_mode_read(parm)
      when 1
        immediate_mode_read(parm)
      when 2
        relative_mode_read(parm)
      else
        raise UnknownOpcodeModeError
      end
    end

    def position_mode_read(parm)
      memory(memory(@position + parm))
    end

    def immediate_mode_read(parm)
      memory(@position + parm)
    end

    def relative_mode_read(parm)
      memory(memory(@position + parm) + @relative_base)
    end

    def update_value(value, parm)
      if opcode_modes[parm - 1] == 2
        relative_mode_update(value, parm)
      else
        position_mode_update(value, parm)
      end
    end

    def position_mode_update(value, parm)
      ensure_memory(memory(@position + parm))
      @input[memory(@position + parm)] = value
    end

    def relative_mode_update(value, parm)
      ensure_memory(memory(@position + parm) + @relative_base)
      @input[memory(@position + parm) + @relative_base] = value
    end
  end
end
