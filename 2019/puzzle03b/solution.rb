#!/usr/local/bin/ruby
require '../solution2019'

class Point
  CONTROLS = {
    r: %i[@xpos +],
    l: %i[@xpos -],
    u: %i[@ypos +],
    d: %i[@ypos -]
  }.freeze

  attr_reader :path

  def initialize
    reset
  end

  def position
    [@xpos, @ypos]
  end

  def move(instruction)
    direction = instruction[0].downcase.to_sym
    distance = instruction[1..-1].to_i
    change_position(direction, distance)
  end

  def reset
    @xpos = @ypos = @steps = 0
    @path = {}
  end

  private

  def change_position(direction, distance)
    distance.times do
      variable = CONTROLS[direction][0]
      operator = CONTROLS[direction][1]

      value = instance_variable_get(variable)
      value = value.send(operator, 1)
      instance_variable_set(variable, value)
      @steps += 1

      @path[position] = @steps unless @path[position]
    end
  end
end

class Solution < Solution2019
  private

  def process_input
    additional_setup
    determine_paths
    calculate_timings
  end

  def calculate_timings
    min_timing = nil
    intersections.each do |point|
      timing = @paths[0][point] + @paths[1][point]
      @answer = min_timing = timing if min_timing.nil? || timing < min_timing
    end
  end

  def intersections
    @intersections ||= @paths[0].keys & @paths[1].keys
  end

  def determine_paths
    @input.each do |line|
      @point.reset
      line.split(',').each { |instruction| @point.move(instruction) }
      @paths << @point.path
    end
  end

  def additional_setup
    @point = Point.new
    @paths = []
  end
end

Solution.new.run! # true
