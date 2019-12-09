module Intcode
  module Memory
    def memory(index)
      ensure_memory(index)
      @input[index]
    end

    def memory=(index, value)
      ensure_memory(index)
      @input[index] = value
    end

    def ensure_memory(index)
      (index + 1 - @input.size).times { @input << 0 } if @input.size < index + 1
    end
  end
end
