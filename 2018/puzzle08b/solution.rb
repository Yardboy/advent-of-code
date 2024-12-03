#!/usr/local/bin/ruby

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end

  def initialize
    @input_lines = 0
    @input = []
    @data = []
    @next_id = 0
    @stack = []
    @current = nil
  end

  def run!
    read_input # :test

    get_next_node

    process_node unless @current.nil? until @input.empty?

    # display

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{sum_up(@data.last)}"
  end

  private

  def sum_up(node)
    sum = 0
    if node[5].empty?
      sum += node[3].sum
    else
      node[3].each do |index|
        child = node[5][index - 1]
        sum += sum_up(child) if child
      end
    end
    sum
  end

  def display
    puts "Cycle: #{@counter}"
    puts '--'
    puts 'Stack:'
    @stack.each { |s| puts "#{s[0]}: #{s[1]}, #{s[2]}, #{s[3].empty? ? 'none' : s[3].join('-')}" }
    puts '--'
    puts 'Data:'
    @data.sort.each { |s| puts "#{s[0]}: #{s[1]}, #{s[2]}, #{s[3].join('-')}" }
    puts '--'
  end

  def process_node
    if @current[4].zero?
      @current[2].times { @current[3] << @input.shift }
      @data << @current
      @current = @stack.pop
      if @current
        @current[5] << @data.last.dup if (@current[1]).positive?
        @current[4] -= 1
      end
    else
      @stack << @current
      get_next_node
    end
  end

  def next_id
    @next_id += 1
  end

  def get_next_node
    @current = [next_id, @input.shift, @input.shift, [], nil, []]
    @current[4] = @current[1]
  end

  def read_input(type = nil)
    if type == :test
      read_test_input
    else
      @input = File.read('input.txt').chomp.split.map(&:to_i)
    end
  end

  def read_test_input
    # raise NoTestInputError
    @input = '2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2'.split.map(&:to_i)
  end
end

Solution.new.run!
