#!/usr/local/bin/ruby

class Solution
  def initialize
    @input = []
    @doubles = 0
    @triples = 0
  end

  def run!
    read_input
    @input.each do |s|
      counts = count_duplicates(s)
      @doubles += 1 if counts.include?(2)
      @triples += 1 if counts.include?(3)
    end
    puts @doubles * @triples
  end

  private

  def count_duplicates(text)
    text.chars.each_with_object({}) do |char, hsh|
      hsh[char] ||= 0
      hsh[char] += 1
    end.select { |_k, v| [2, 3].include?(v) }.values.uniq
  end

  def read_input
    File.open('input.txt', 'r') do |f|
      f.each_line do |line|
        @input << line.chomp
      end
    end
  end
end

Solution.new.run!
