#! /usr/bin/ruby

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input_lines = 0
    @input = []
  end

  def run!
    get_input #:test
    @input = @input.split('')
    react_polymer

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@input.join.size}"
  end

  private

  def react_polymer
    flag = true
    while flag do
      flag = false
      start = 0
      (start..@input.size - 2).each do |i|
        if @input[i] != @input[i + 1] && @input[i].downcase == @input[i + 1].downcase
          @input.delete_at(i + 1)
          @input.delete_at(i)
          flag = true
          start = i - 1
          break
        end
      end
    end
  end

  def get_input type = nil
    if type == :test
      @input = test_input
    else
      @input = File.read('input.txt').chomp
    end
  end

  def test_input
    # raise NoTestInputError
    'dabAcCaCBAcCcaDA'
  end
end

Solution.new.run!
