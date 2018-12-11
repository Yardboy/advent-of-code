#! /usr/bin/ruby
class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input = nil
    @answer = [0, 0, 0]
    @grid_size = nil
    @grid = []
  end

  def run!
    get_input #:test
    build_grid
    calculate_power_levels(@input)
    find_max_subgrid(3,3)

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@answer}"
  end

  private

  def find_max_subgrid(sizex, sizey)
    (1..(@grid_size - sizex + 1)).each do |x|
      (1..(@grid_size - sizey + 1)).each do |y|
        total = 0
        sizex.times do |i|
          sizey.times do |j|
            total += @grid[x + i][y + j]
          end
        end
        if total > @answer[2]
          @answer = [x, y, total]
        end
      end
    end
  end

  def calculate_power_levels(serial_number)
    (0..(@grid_size)).each do |x|
      (0..(@grid_size)).each do |y|
        @grid[x][y] = power_level(x, y, serial_number)
      end
    end
  end

  def power_level(x,y, serial_number)
    rack_id = x + 10
    (((rack_id * y) + serial_number) * rack_id).to_s.split('')[-3].to_i - 5
  end

  def build_grid
    (@grid_size + 1).times { @grid << [nil] * (@grid_size + 1) }
  end

  def get_input type = nil
    if type == :test
      get_test_input
    else
      @input = 3031
    end
    @grid_size = 300
  end

  def get_test_input
    # raise NoTestInputError
    #@input = 18
    @input = 42
  end
end

Solution.new.run!
