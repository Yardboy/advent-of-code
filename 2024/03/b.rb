#!/usr/local/bin/ruby

require '../solution2024.rb'

class Solution < Solution2024
  private

  # override
  def additional_setup
    @answer = 0
    @input = @input.join
  end

  def process_input
    instructions_for(remove_donts).each do |instruction|
      @answer += execute(instruction)
    end
  end

  def remove_donts
    dos = ''
    donts = ''
    flag = false
    @input.split('').each do |char|
      if flag
        donts += char
        flag = !(donts[-4..] == 'do()')
      else
        dos += char
        flag = dos[-7..] == "don't()"
      end
    end
    dos
  end

  def instructions_for(text)
    text.scan(/mul\(\d{,3}\,\d{,3}\)/)
  end

  def execute(instruction)
    a, b = instruction.match(/\d{,3},\d{,3}/).to_s.split(',').map(&:to_i)
    a * b
  end
end

Solution.new.run! testmode: false
# 80747545
