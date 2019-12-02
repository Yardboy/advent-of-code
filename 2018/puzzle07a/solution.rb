#!/usr/local/bin/ruby

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end

  def initialize
    @input_lines = 0
    @input = []
    @data = {}
    @answers = []
  end

  def run!
    read_input #:test
    get_data

    until @data.empty? do
      completed = @data.select { |step, prereqs| prereqs.empty? }.map(&:to_a).flatten.sort.first
      @answers << completed
      @data.delete(completed)
      @data.each do |step, prereqs|
        prereqs.delete(completed)
        @data[step] =  prereqs
      end
    end

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@answers.join}"
  end

  private

  def get_data
    @input.each do |prereq, step|
      @data[prereq] ||= []
      @data[step] ||= []
      @data[step] << prereq
    end
  end

  def read_input type = nil
    if type == :test
      read_test_input
    else
      File.open('input.txt', 'r') do |f|
        f.each_line do |line|
          @input << line.scan(/\s.\s/).map(&:strip)
          @input_lines += 1
        end
      end
    end
  end

  def read_test_input
    # raise NoTestInputError
    @input = [
      ['C', 'A'],
      ['C', 'F'],
      ['A', 'B'],
      ['A', 'D'],
      ['B', 'E'],
      ['D', 'E'],
      ['F', 'E']
    ]
  end
end

Solution.new.run!
