#! /usr/bin/ruby

class Solution
  def initialize
    @input = []
    @doubles = 0
    @triples = 0
  end

  def run!
    get_input
    @input.each do |s|
      counts = count_duplicates(s)
      @doubles += 1 if counts.include?(2)
      @triples += 1 if counts.include?(3)
    end
    puts @doubles * @triples
  end

  private

  def count_duplicates(text)
    text.split('').each_with_object({}) { |char, hsh| hsh[char] ||= 0; hsh[char] += 1 }.select { |k,v| v == 2 || v == 3 }.values.uniq
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
