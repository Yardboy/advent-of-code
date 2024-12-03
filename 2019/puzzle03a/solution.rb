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
    distance = instruction[1..].to_i
    change_position(direction, distance)
  end

  def reset
    @xpos = @ypos = 0
    @path = []
  end

  private

  def change_position(direction, distance)
    distance.times do
      variable = CONTROLS[direction][0]
      operator = CONTROLS[direction][1]

      value = instance_variable_get(variable)
      value = value.send(operator, 1)
      instance_variable_set(variable, value)

      @path << position
    end
  end
end

class Solution < Solution2019
  private

  # override
  def additional_setup
    @point = Point.new
    @paths = []
  end

  def process_input
    determine_paths
    calculate_distances
  end

  def calculate_distances
    min_distance = nil
    intersections.each do |point|
      distance = point[0].abs + point[1].abs
      @answer = min_distance = distance if min_distance.nil? || distance < min_distance
    end
  end

  def intersections
    @intersections ||= @paths[0] & @paths[1]
  end

  def determine_paths
    @input.each do |line|
      @point.reset
      line.split(',').each { |instruction| @point.move(instruction) }
      @paths << @point.path
    end
  end
end

Solution.new.run! # true
