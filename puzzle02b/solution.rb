#! /usr/bin/ruby

class Solution
  def initialize
    @input = []
    @answer = nil
  end

  def run!
    get_input
    @input[0..-2].each_with_index do |s1, i|
      @input[(i + 1)..-1].each do |s2|
        @answer = get_answer(s1, s2) if one_difference?(s1, s2)
        break if @answer
      end
      break if @answer
    end
    puts @answer
  end

  private

  def get_answer(text1, text2)
    text1.split('').zip(text2.split('')).map(&:uniq).select { |arr| arr.size == 1 }.flatten.join
  end

  def one_difference?(text1, text2)
    text1.split('').zip(text2.split('')).map { |arr| arr.uniq.count }.select { |i| i > 1 }.size == 1
  end

  def get_input
    File.open('input.txt', 'r') do |f|
      f.each_line do |line|
        @input << line.chomp
      end
    end
  end
end

Solution.new.run!
