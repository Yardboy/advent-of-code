#! /usr/bin/ruby

class Solution
  class MissingInputError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input_lines = 0
    @input = []
    @fabric = []
    @answer = []
  end

  def run!
    initialize_fabric
    get_input #:test
    @input.each { |parms| mark_squares(parms) }
    @input.each { |parms| check_for_overlaps(parms) }

    puts "Input Lines: #{@input_lines}"
    puts "Fabric Size: #{@max_cols} X #{@max_rows}"
    puts "Answer: #{@answer.join(', ')}"
  end

  private

  def initialize_fabric
    @fabric = [[0]]
    @max_rows = @fabric.size
    @max_cols = @fabric.first.size
  end

  def check_for_overlaps(config)
    parms = parse_configs(config)
    key, left, top, width, height = parms.map(&:to_i)
    overlap = false
    (top..(top + height - 1)).each do |row|
      (left..(left + width - 1)).each do |col|
        overlap = true if @fabric[row][col] > 1
      end
    end
    @answer << key unless overlap
  end

  def mark_squares(config)
    parms = parse_configs(config)
    raise MissingInputError if parms.any? { |parm| parm.nil? || parm.strip == '' }
    key, left, top, width, height = parms.map(&:to_i)

    @max_cols = [@max_cols, left + width].max
    @max_rows = [@max_rows, top + height].max
    update_fabric

    (top..(top + height - 1)).each do |row|
      (left..(left + width - 1)).each do |col|
        @fabric[row][col] += 1
      end
    end
  end

  def update_fabric
    if @fabric.first.size < @max_cols
      @fabric.each do |row|
        (@max_cols - row.size).times { row << 0 }
      end
    end
    if @fabric.size < @max_rows
      (@max_rows - @fabric.size).times { @fabric << [0] * @max_cols }
    end
  end

  def parse_configs(text)
    text.gsub(/[\#\@\:]/, '').gsub(/[,x]/, ' ').squeeze(' ').split(' ')
  end

  def get_input type = nil
    if type == :test
      get_test_input
    else
      File.open('input.txt', 'r') do |f|
        f.each_line do |line|
          @input << line
          @input_lines += 1
        end
      end
    end
  end

  def get_test_input
    # raise NoTestInputError
    @input = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]
  end
end

Solution.new.run!
