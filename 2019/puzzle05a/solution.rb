#!/usr/local/bin/ruby

require '../solution2019'

class Solution < Solution2019
  private

  def process_input
    @position = 0
    send "opcode#{opcode_instruction}" while opcode_instruction != 99
  end

  def opcode
    format('%05i', @input[@position])
  end

  def opcode_instruction
    opcode[-2..-1].to_i
  end

  def opcode_modes
    opcode[0..-3].split('').map(&:to_i).reverse
  end

  def update_input
    @input[1] = 12
    @input[2] = 2
  end

  def process_opcode(opcode)
    send "opcode#{opcode}"
  end

  def opcode1
    update_value(value_by_mode(1) + value_by_mode(2), 3)
    move_pointer(4)
  end

  def opcode2
    update_value(value_by_mode(1) * value_by_mode(2), 3)
    move_pointer(4)
  end

  def opcode3
    update_value(user_input, 1)
    move_pointer(2)
  end

  def opcode4
    puts @answer = value_by_mode(1)
    move_pointer(2)
  end

  def move_pointer(value)
    @position += value
  end

  def value_by_mode(parm)
    if opcode_modes[parm - 1].zero?
      position_mode(parm)
    else
      immediate_mode(parm)
    end
  end

  def position_mode(parm)
    @input[@input[@position + parm]]
  end

  def immediate_mode(parm)
    @input[@position + parm]
  end

  def update_value(value, parm)
    @input[@input[@position + parm]] = value
  end

  def user_input
    puts 'A single ping, Vasilli: '
    begin
      system('stty raw -echo')
      str = STDIN.getc
    ensure
      system('stty -raw echo')
    end
    str.chr.to_i
  end

  # override
  def read_input
    super
    @input = @input.first.split(',').map(&:to_i)
  end
end

Solution.new.run! # true