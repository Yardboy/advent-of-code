#!/usr/local/bin/ruby

require '../solution2021'

class Solution < Solution2021
  private

  # override
  def additional_setup
    @input = @input.map { |cmd| { direction: cmd.split.first, distance: cmd.split.last.to_i } }
    @answer = 0
    @pos = 0
    @depth = 0
  end

  def process_input
    @input.each { |command| move(**command) }
    @answer = @pos * @depth
  end

  def move(direction: nil, distance: 0)
    case direction
    when 'forward'
      @pos += distance
    when 'down'
      @depth += distance
    when 'up'
      @depth -= distance
    end
  end
end

Solution.new.run! testmode: false
# 2215080
