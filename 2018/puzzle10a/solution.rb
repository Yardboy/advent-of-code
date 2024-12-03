#!/usr/local/bin/ruby

Point = Struct.new(:position, :velocity) do
  attr_reader :original_position, :original_velocity

  def move
    @original_position ||= position.dup
    @original_velocity ||= velocity.dup
    position[0] += velocity[0]
    position[1] += velocity[1]
  end
end

class Solution
  # answer is ZAEKAJGC
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end

  def initialize
    @input_lines = 0
    @input = []
    @points = []
  end

  def run!
    read_input # :test
    set_initial_points

    i = 0
    while i += 1
      @points.each(&:move)
      # when distance between max and min y of all points is < 10, then we have a message
      break if check_distance < 10 || i == 100_000
    end

    display

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{i}"
  end

  private

  def check_distance
    point_ys = @points.map { |p| p.position[1] }
    point_ys.max - point_ys.min
  end

  def display
    # get x and y maximums
    xmax = @points.map { |p| p.position[0] }.max
    ymax = @points.map { |p| p.position[1] }.max
    # initiate output grid
    output = []
    (ymax + 1).times { output << (['.'] * (xmax + 1)) }
    # populate output grid
    @points.each { |p| output[p.position[1]][p.position[0]] = '#' }
    # delete any rows that are all '.'
    output.delete_if { |o| o.uniq == ['.'] }
    # delete first column repeatedly until first column includes something other than '.'
    output.each { |o| o.delete_at(0) } while output.all? { |o| o[0] == '.' }
    # display message
    output.each { |o| puts o.join }
  end

  def set_initial_points
    @input.each do |line|
      position, velocity = line.scan(/<[^\>]*>/).map { |coord| coord.gsub(/[\>\<\s]/, '').split(',').map(&:to_i) }
      @points << Point.new(position, velocity)
    end
  end

  def read_input(type = nil)
    if type == :test
      read_test_input
    else
      File.open('input.txt', 'r') do |f|
        f.each_line do |line|
          @input << line
          @input_lines += 1
        end
      end
    end
  end

  def read_test_input
    # raise NoTestInputError
    File.open('test-input.txt', 'r') do |f|
      f.each_line do |line|
        @input << line
        @input_lines += 1
      end
    end
  end
end

Solution.new.run!
