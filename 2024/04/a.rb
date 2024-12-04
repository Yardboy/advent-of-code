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
        [
          4.times.map { |i| [row + i, col] },
          4.times.map { |i| [row - i, col] },
          4.times.map { |i| [row, col + i] },
          4.times.map { |i| [row, col - i] },
          4.times.map { |i| [row + i, col + i] },
          4.times.map { |i| [row + i, col - i] },
          4.times.map { |i| [row - i, col + i] },
          4.times.map { |i| [row - i, col - i] }
        ].each { |coords| check_for_xmas(coords) }
      end
    end
  end

  def check_for_xmas(coords)
    return if coords.any? { |row, col| row < 0 || row > @rows - 1 || col < 0 || col > @cols - 1 }

    check = coords.map { |row, col| @input[row][col] }.join('')
    @keep << check
    @answer += 1 if check == 'XMAS'
  end
end

Solution.new.run! testmode: false
# 2414
