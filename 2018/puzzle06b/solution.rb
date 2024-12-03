#!/usr/local/bin/ruby

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end

  def initialize
    @input_lines = 0
    @input = []
    @canvas = nil
  end

  def run!
    read_input # :test
    cols = @input.map(&:first).max + 2
    rows = @input.map(&:last).max + 1
    @canvas = rows.times.map { [nil] * cols }

    @canvas.first.size.times.each do |x|
      @canvas.size.times.each do |y|
        @canvas[y][x] = '#' if @input.map { |point| distance(point, [x, y]) }.sum < 10_000
      end
    end

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@canvas.flatten.compact.size}"
  end

  private

  def distance(point1, point2)
    (point1[0] - point2[0]).abs + (point1[1] - point2[1]).abs
  end

  def read_input(type = nil)
    if type == :test
      read_test_input
    else
      File.open('input.txt', 'r') do |f|
        f.each_line do |line|
          @input << line.split(',').map { |x| x.strip.to_i }
          @input_lines += 1
        end
      end
    end
  end

  def read_test_input
    # raise NoTestInputError
    @input = [
      '1, 1',
      '1, 6',
      '8, 3',
      '3, 4',
      '5, 5',
      '8, 9'
    ].map { |line| line.split(',').map { |x| x.strip.to_i } }
  end
end

Solution.new.run!
