#!/usr/local/bin/ruby

require '../solution2021'

class Solution < Solution2021
  private

  # override
  def additional_setup
    @winner = nil
    @calls = @input.first.split(',').map(&:to_i)
    @current = nil
    @cards = []
    build_cards
    @answer = 0
  end

  def process_input
    @calls.each do |number|
      call_number(number)
      check_for_winners
      break if @winner
    end

    @answer = @winner.total * @current
  end

  def call_number(number)
    @current = number
    @cards.each { |card| card.mark_number(number) }
  end

  def check_for_winners
    @winner = @cards.select(&:winner?).first
  end

  def build_cards
    lines = []
    @input[2..].each do |line|
      if line == ''
        @cards << BingoCard.new(lines)
        lines = []
      else
        lines << line
      end
    end
    @cards << BingoCard.new(lines) unless lines.empty?
  end
end

class BingoCard
  attr_reader :board

  def initialize(lines)
    @lines = lines
    @board = [[nil] * 5, [nil] * 5, [nil] * 5, [nil] * 5, [nil] * 5]
    @save_board = [[nil] * 5, [nil] * 5, [nil] * 5, [nil] * 5, [nil] * 5]
    parse_lines
  end

  def total
    board.flatten.compact.sum
  end

  def winner?
    @board.any? { |row| row.compact.empty? } || (0..4).any? { |n| @board.map { |row| row[n] }.compact.empty? }
  end

  def mark_number(number)
    (0..4).each do |row|
      (0..4).each do |col|
        @board[row][col] = nil if @board[row][col] == number
      end
    end
  end

  def parse_lines
    @lines.each_with_index do |line, row|
      line.split.each_with_index do |number, col|
        @board[row.to_i][col.to_i] = @save_board[row.to_i][col.to_i] = number.to_i
      end
    end
  end
end

Solution.new.run! testmode: false
# 69579
