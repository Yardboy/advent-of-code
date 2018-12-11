#! /usr/bin/ruby
  # takes a couple minutes to run, could better, I'm sure
class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input = nil
    @answer = [0, 0, 0, 0]
    @grid_size = nil
    @grid = []
  end

  def run!
    get_input #:test
    build_grid
    calculate_power_levels(@input)
    1.upto(300) { |i| calculate_subgrids(i) }

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@answer}"
  end

  private

  def calculate_subgrids(subgrid_size)
    (1..(@grid_size - subgrid_size + 1)).each do |x|
      (1..(@grid_size - subgrid_size + 1)).each do |y|
        total = @grid[x][y][1]
        subgrid_size.times do |i|
          total += @grid[x + subgrid_size - 1][y + i][0] unless i + 1 == subgrid_size
          total += @grid[x + i][y + subgrid_size - 1][0]
        end
        @grid[x][y][1] = total
        if total > @answer[2]
          @answer = [x, y, total, subgrid_size]
        end
      end
    end
  end

  def calculate_power_levels(serial_number)
    (0..(@grid_size)).each do |x|
      (0..(@grid_size)).each do |y|
        @grid[x][y] = [power_level(x, y, serial_number), 0]
      end
    end
  end

  def power_level(x,y, serial_number)
    rack_id = x + 10
    (((rack_id * y) + serial_number) * rack_id).to_s.split('')[-3].to_i - 5
  end

  def build_grid
    (@grid_size + 1).times { @grid << [[nil, nil]] * (@grid_size + 1) }
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
    @input = 18
    #@input = 42
  end
end

Solution.new.run!
