!/usr/local/bin/ruby
class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input_lines = 0
    @input = []
    @pots = []
    @rules = {}
    @offset = 0
    @generations = []
    @answer = 0
  end

  def run!
    read_input #:test
    @input.delete_if { |i| i.strip == '' }
    parse_input

    i = 0
    while i < 20 do
      pad_pots
      capture_generation if i == 0
      next_generation
      capture_generation
      i += 1
    end

    @generations.each_with_index do |g, index|
      puts "#{'%2d' % index}; #{g}"
    end

    @pots.each_with_index do |pot, index|
      @answer += (index - @offset) if pot == '#'
    end

    puts "Answer: #{@answer}"
  end

  private

  def capture_generation
    @generations << @pots.join
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
    while @pots[-3..-1].any? { |x| x == '#' }
      @pots << '.'
    end
  end

  def parse_input
    @input.each do |line|
      next if line.strip == ''
      if line.include?('initial')
        line.split(':').last.strip.split('').each do |x|
          @pots << x
        end
      else
        parms = line.split(' => ')
        @rules[parms[0]] = parms[1]
      end
    end
  end

  def read_input type = nil
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
