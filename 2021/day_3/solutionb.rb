#!/usr/local/bin/ruby

require '../solution2021'

class Solution < Solution2021
  private

  # override
  def additional_setup
    @input = @input.map { |line| line.split('').map(&:to_i) }
    @tracker = []
    @answer = 0
  end

  def process_input
    oxygen = filter_data(:find_most_common).join('')
    co2 = filter_data(:find_least_common).join('')

    @answer = oxygen.to_i(2) * co2.to_i(2)
  end

  def filter_data(mthd)
    @data = @input.dup
    indices.each do |n|
      next if @data.size == 1

      keep = send(mthd, n)
      @data = @data.select { |digits| digits[n] == keep }
    end
    @data
  end

  def indices
    @indices ||= @input.first.size.times.to_a
  end

  def find_most_common(index)
    sum_digits(index).negative? ? 0 : 1
  end

  def find_least_common(index)
    sum_digits(index).negative? ? 1 : 0
  end

  def sum_digits(index)
    @data.map { |digits| (digits[index].positive? ? 1 : -1) }.sum
  end
end

Solution.new.run!  testmode: false
# 2817661
