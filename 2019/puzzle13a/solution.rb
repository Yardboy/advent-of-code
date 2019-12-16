#!/usr/local/bin/ruby
require '../solution2019'
require '../intcode'

class Board
  attr_reader :tiles

  def initialize(instructions)
    @tiles = []
    take_turn(instructions)
  end

  def take_turn(instructions)
    instructions.each_slice(3) do |posx, posy, type|
      @score = type and next if [posx, posy] == [-1, 0]
      ensure_board_size(posx, posy)
      update_board(posx, posy, type)
    end
  end

  def draw
    display = "\n  #{ruler}\n"
    @tiles.each_with_index do |row, index|
      display += "#{index % 10} #{row.map { |tile| char(tile) }.join('')} #{index % 10}\n"
    end
    display += "  #{ruler}\n"
    puts display
  end

  private

  def char(type)
    { '0' => '.', '1' => '#', '2' => '█', '3' => '_', '4' => 'O' }[type.to_s]
  end

  def update_board(posx, posy, type)
    @tiles[posy][posx] = type
  end

  def ensure_board_size(posx, posy)
    (posy + 1 - @tiles.size).times { @tiles << [] }
    @tiles.each_with_index do |row, index|
      (posx + 1 - row.size).times { @tiles[index] << '' }
    end
  end

  def ruler
    @ruler ||= (0..@tiles.first.size - 1).map { |index| index % 10 }.join('')
  end
end

class Solution < Solution2019
  private

  # override
  def additional_setup
    @input = @input.first
  end

  def process_input
    run_computer!(nil)
    board.draw
    @answer = board.tiles.flatten.select { |tile| tile == 2 }.size
  end

  def run_computer!(input)
    computer.run!(input, @test)
  end

  def board
    @board ||= Board.new(computer.outputs)
  end

  def computer
    @computer ||= Intcode::Computer.new(@input)
  end
end

Solution.new.run! # true
