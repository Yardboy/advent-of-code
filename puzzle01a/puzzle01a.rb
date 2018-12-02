#! /usr/bin/ruby

class Puzzle01a
  def initialize
    @input = []
    @value = 0
  end

  def run!
    get_input
    @input.each { |i| @value += i }
    puts @value
  end

  private
  
  def get_input
    File.open('input.txt', 'r') do |f|
      f.each_line do |line|
        @input << line.to_i
      end
    end
  end
end

Puzzle01a.new.run!
