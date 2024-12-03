#!/usr/local/bin/ruby
class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end

  def initialize
    @input_lines = 0
    @input = []
    @pots = []
    @rules = {}
    @offset = 0
    @answer = 0
    @last = 0
    @i = 0
    @pattern = ''
  end

  def run!
    read_input # :test
    @input.delete_if { |i| i.strip == '' }
    parse_input

    count = 0
    while @i < 1_000
      @last = @answer
      pad_pots
      next_generation
      @i += 1
      calc_sum
      p = pattern
      count += 1 if p == @pattern
      break if count > 20

      @pattern = p
    end

    # it's not practical/feasible to run 50 billion iterations, however there is
    # a simple shortcut
    # at some point, the pattern stabilizes and starts to shift in a predictable way
    # when that happens, the delta in the calculated value is the same each step
    # so you can compute the answer by figuring the number of steps left times
    # the per step delta plus the last answer

    @answer = ((50_000_000_000 - @i) * (@answer - @last)) + @answer
    puts "Answer: #{@answer}"
  end

  private

  def pattern
    x = @pots.dup
    x.shift while x.first == '.'
    x.pop while x.last == '.'
    x.join
  end

  def calc_sum
    @answer = 0
    @pots.each_with_index do |pot, index|
      @answer += (index - @offset) if pot == '#'
    end
  end

  def next_generation
    pot_keys.each do |key|
      rule = @rules[key[1]]
      @pots[key[0]] = rule || '.'
    end
  end

  def pot_keys
    (2..(@pots.size - 3)).map { |i| [i, @pots[(i - 2)..(i + 2)].join] }
  end

  def pad_pots
    while @pots[0..2].any? { |x| x == '#' }
      @pots.unshift('.')
      @offset += 1
    end
    @pots << '.' while @pots[-3..].any? { |x| x == '#' }
  end

  def parse_input
    @input.each do |line|
      next if line.strip == ''

      if line.include?('initial')
        line.split(':').last.strip.chars.each do |x|
          @pots << x
        end
      else
        parms = line.split(' => ')
        @rules[parms[0]] = parms[1]
      end
    end
  end

  def read_input(type = nil)
    if type == :test
      read_test_input
    else
      File.open('input.txt', 'r') do |f|
        f.each_line do |line|
          @input << line.chomp
          @input_lines += 1
        end
      end
    end
  end

  def read_test_input
    # raise NoTestInputError
    File.open('test-input.txt', 'r') do |f|
      f.each_line do |line|
        @input << line.chomp
        @input_lines += 1
      end
    end
  end
end

Solution.new.run!
