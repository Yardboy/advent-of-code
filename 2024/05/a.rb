#!/usr/local/bin/ruby

require '../solution2024.rb'

class Solution < Solution2024
  UP = '^'.freeze
  DOWN = 'v'.freeze
  LEFT = '<'.freeze
  RIGHT = '>'.freeze 
  OBSTACLE = '#'.freeze

  private

  # override
  def additional_setup
    split_input(delimiter: '')
    @rows = @input.size
    @cols = @input.map(&:size).max
    @answer = 0
    @current_position = []
    @direction = nil
    @visited = []
  end

  def process_input
    find_starting_position
    until out_of_map?
      if look == OBSTACLE
        turn
      else
        move
      end
    end
    @answer = @visited.uniq.size - 1
  end

  def out_of_map?(pos: @current_position)
    pos.first.negative? || pos.first > @rows - 1 ||
      pos.last.negative? || pos.last > @cols - 1
  end

  def find_starting_position
    @rows.times.each do |row|
      @cols.times.each do |col|
        @direction = @input[row][col]
        if [UP, DOWN, LEFT, RIGHT].include?(@direction)
          @current_position = [row, col]
          @visited << @current_position
        end
        break unless @current_position.empty?
      end
      break unless @current_position.empty?
    end
  end

  def move
    @current_position = next_position
    @visited << @current_position
  end

  def turn
    @direction = {
      UP => RIGHT,
      RIGHT => DOWN,
      DOWN => LEFT,
      LEFT => UP
    }[@direction]
  end

  def next_position
    case @direction
    when UP
      [@current_position.first - 1, @current_position.last]
    when DOWN
      [@current_position.first + 1, @current_position.last]
    when LEFT
      [@current_position.first, @current_position.last - 1]
    when RIGHT
      [@current_position.first, @current_position.last + 1]
    end    
  end

  def look
    return nil if out_of_map?(pos: next_position)

    @input[next_position.first][next_position.last]    
  end
end

Solution.new.run! testmode: false
# 4977
