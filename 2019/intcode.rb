class Intcode < Solution2019
  attr_reader :state, :position

  # override
  def run!(user_inputs, test = false)
    @user_inputs = Array(user_inputs)
    @test = test
    @state = 'running'
    @position = 0
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
    send "opcode#{opcode_instruction}" while @state == 'running'
    @answer
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
    @answer = value_by_mode(1)
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

  # halt
  def opcode99
    @state = 'done'
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
    @user_inputs.shift
  end

  # override
  def read_input
    super
    @input = @input.first.split(',').map(&:to_i)
  end
end
