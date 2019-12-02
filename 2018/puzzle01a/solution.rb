#!/usr/local/bin/ruby

class Solution
  def initialize
    @input = []
    @value = 0
  end

  def run!
    read_input
    @input.each { |i| @value += i }
    puts @value
  end

  private

  def read_input
    File.open('input.txt', 'r') do |f|
      f.each_line do |line|
        @input << line.to_i
      end
    end
  end
end

Solution.new.run!
