#!/usr/local/bin/ruby

require '../solution2024.rb'

class Solution < Solution2024

  private

  # override
  def additional_setup
    @answer = 0
  end

  def process_input
    @input.each do |line|
      value, numbers = line.split(':')
      value = value.to_i
      numbers = numbers.split(' ').map(&:to_i)
      operators(value, numbers).each do |map|
        result = check_test_value(numbers, map.split('')) == value
        @answer += value and break if result
      end
    end
  end

  def check_test_value(numbers, map)
    test = numbers.first
    numbers[1..].each do |number|
      operator = map.shift.to_i
      if operator.zero?
        test += number
      elsif operator == 1
        test *= number
      else
        test = "#{test.to_s}#{number.to_s}".to_i
      end
    end
    test
  end

  # get a base 3 number for the slots where digits represent the options
  def operators(value, numbers)
    options = 3
    slots = numbers.size - 1
    target = options ** slots
    target.times.map { |i| i.to_s(3).rjust(slots, '0') }
  end
end

Solution.new.run! testmode: false
# 37598910447546
