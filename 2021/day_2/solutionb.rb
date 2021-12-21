#!/usr/local/bin/ruby

require '../solution2021'

class Solution < Solution2021
  private

  # override
  def additional_setup
    @input = @input.map { |cmd| { direction: cmd.split.first, distance: cmd.split.last.to_i } }
    @answer = 0
    @pos = @depth = @aim = 0
  end

  def process_input
    @input.each { |command| move(**command) }
    @answer = @pos * @depth
  end

  def move(direction: nil, distance: 0)
    case direction
    when 'forward'
      @pos += distance
      @depth += (@aim * distance)
    when 'down'
      @aim += distance
    when 'up'
      @aim -= distance
    end
  end
end

Solution.new.run! testmode: false
# 1864715580
