module Intcode
  module Modes
    def value_by_mode(parm)
      case opcode_modes[parm - 1]
      when 0
        position_mode(parm)
      when 1
        immediate_mode(parm)
      when 2
        relative_mode(parm)
      else
        raise StandardError
      end
    end

    def position_mode(parm)
      memory(memory(@position + parm))
    end

    def immediate_mode(parm)
      memory(@position + parm)
    end

    def relative_mode(parm)
      memory(memory(@position + parm) + @relative_base)
    end

    def update_value(value, parm)
      if opcode_modes[parm - 1] == 2
        relative_mode_update(value, parm)
      else
        immediate_mode_update(value, parm)
      end
    end

    def immediate_mode_update(value, parm)
      ensure_memory(memory(@position + parm))
      @input[memory(@position + parm)] = value
    end

    def relative_mode_update(value, parm)
      ensure_memory(memory(@position + parm) + @relative_base)
      @input[memory(@position + parm) + @relative_base] = value
    end
  end
end
