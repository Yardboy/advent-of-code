#! /usr/bin/ruby

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input_lines = 0
    @input = []
    @units = nil
  end

  def run!
    get_input #:test
    get_units
    process_reactions

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@units.map(&:last).min}"
  end

  private

  def process_reactions
    @units.each do |data|
      unit_input = @input.dup
      unit_input.delete(data[0])
      unit_input.delete(data[0].upcase)
      polymer = react_polymer(unit_input)
      data[1] = polymer.size
    end
  end

  def get_units
    @units = @input.map(&:downcase).uniq.map { |x| [x, 0] }
  end

  def react_polymer(polymer)
    reacted = []
    unreacted = polymer

    until polymer.empty?
      unit1 = reacted.pop if unit1.nil?
      unit1 = unreacted.shift if unit1.nil?
      unit2 = unreacted.shift
      if react?(unit1, unit2)
        unit1 = unit2 = nil
      else
        reacted << unit1
        reacted << unit2 if polymer.empty?
        unit1 = unit2
      end
    end
    reacted
  end

  def react?(unit1, unit2)
    unit1 != unit2 && unit1.downcase == unit2.downcase
  end

  def get_input type = nil
    if type == :test
      @input = test_input.split('')
    else
      @input = File.read('input.txt').chomp.split('')
    end
  end

  def test_input
    # raise NoTestInputError
    'dabAcCaCBAcCcaDA'
  end
end

Solution.new.run!
