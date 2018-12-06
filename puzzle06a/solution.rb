#! /usr/bin/ruby

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input_lines = 0
    @input = []
    @canvas = nil
  end

  def run!
    get_input #:test
    cols = @input.map(&:first).max + 2
    rows = @input.map(&:last).max + 1
    @canvas = rows.times.map { [nil] * cols }

    @canvas.first.size.times.each do |x|
      @canvas.size.times.each do |y|
        distances = []
        @input.each_with_index { |point, index| distances << [distance(point, [x, y]), index] }
        min = distances.min
        if distances.map(&:first).count(min[0]) > 1
          @canvas[y][x] = '.'
        else
          @canvas[y][x] = min[1]
        end
      end
    end

    borders = (@canvas.first + @canvas.map(&:first) + @canvas.map(&:last) + @canvas.last).flatten.uniq

    @answers = @canvas.flatten.reject { |p| borders.include?(p) }.each_with_object({}) { |p, hsh| hsh[p.to_s] ||= 0; hsh[p.to_s] += 1 }

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@answers.values.max}"
  end

  private

  def distance(point1, point2)
    (point1[0] - point2[0]).abs + (point1[1] - point2[1]).abs
  end

  def get_input type = nil
    if type == :test
      get_test_input
    else
      File.open('input.txt', 'r') do |f|
        f.each_line do |line|
          @input << line.split(',').map { |x| x.strip.to_i }
          @input_lines += 1
        end
      end
    end
  end

  def get_test_input
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
