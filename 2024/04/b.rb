#!/usr/local/bin/ruby

require '../solution2024.rb'

class Solution < Solution2024
  private

  # override
  def additional_setup
    @answer = 0
    @keep = []
    @input = @input.map { |line| line.split('') }
    @rows = @input.size
    @cols = @input.first.size
  end

  def process_input
    @rows.times do |row|
      @cols.times do |col|
        coords = [[row, col], [row, col + 2], [row + 2, col + 2], [row + 2, col], [row + 1, col + 1]]
        check_for_xmas(coords)
      end
    end
  end

  def check_for_xmas(coords)
    return if coords.any? { |row, col| row < 0 || row > @rows - 1 || col < 0 || col > @cols - 1 }
 
    nw, ne, se, sw, cntr = coords
    return unless input_char(cntr) == 'A'

    if [input_char(nw), input_char(se)].sort.join('') == 'MS' && [input_char(ne), input_char(sw)].sort.join('') == 'MS'
      @answer += 1
    end
  end

  def input_char(args)
    x, y = *args
    @input[x][y]
  end
end

Solution.new.run! testmode: false
# 1871