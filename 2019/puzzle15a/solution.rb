#!/usr/local/bin/ruby
require '../solution2019'
require '../intcode'

class Solution < Solution2019
  DONTKNOW = ' '.freeze
  OPENTILE = '.'.freeze
  WALLTILE = '#'.freeze
  O2SYSTEM = '@'.freeze
  POSITION = 'O'.freeze
  STARTPOS = 'X'.freeze

  private

  # override
  def additional_setup
    @input = @input.first
    @size = 50
    @board = Array.new(@size) { Array.new(@size, DONTKNOW) }
    @status = nil
    @curx = (@size / 2).ceil
    @cury = (@size / 2).ceil
    @board[@curx][@cury] = OPENTILE
    @moves = []
    @turns = 0
  end

  def process_input
    map_area
  end

  def fill_in_map
    (1..(@board.size - 2)).each do |posy|
      (1..(@board[posy].size - 2)).each do |posx|
        next unless @board[posy][posx] == DONTKNOW

        @curx = posx
        @cury = posy
        @board[posy][posx] = WALLTILE if deadend?
      end
    end
  end

  def map_area
    until @status == 2
      @turns += 1
      take_turn
      backup while deadend? && !@moves.empty?
    end
  end

  def take_turn
    x, y, dir = next_move
    computer.clear_output!
    run_computer!(dir)
    resolve(x, y)
  end

  def resolve(posx, posy)
    if @status.zero?
      @board[posy][posx] = WALLTILE
    elsif @status == 1
      @board[posy][posx] = OPENTILE
      @moves << [@curx = posx, @cury = posy]
    else
      @board[posy][posx] = O2SYSTEM
      @answer = [posx, posy]
    end
  end

  def backup
    @moves.pop
    previous = @moves.last
    dir = direction_to(previous[0], previous[1])
    run_computer!(dir)
    @board[@cury][@curx] = WALLTILE
    @curx, @cury = previous
  end

  def next_move
    posx, posy = (untraveled.empty? ? open : untraveled).sample(1).first
    [posx, posy, direction_to(posx, posy)]
  end

  def direction_to(posx, posy)
    directions[[posx - @curx, posy - @cury]]
  end

  def directions
    {
      [0, -1] => 1, # north
      [0,  1] => 2, # south
      [-1, 0] => 3, # west
      [1,  0] => 4  # east
    }
  end

  def open
    choices.select { |x, y| @board[y][x] == OPENTILE }
  end

  def untraveled
    choices.select { |x, y| @board[y][x] == DONTKNOW }
  end

  def deadend?
    choices.select { |x, y| @board[y][x] == WALLTILE }.size >= 3
  end

  def choices
    [
      [@curx - 1, @cury],
      [@curx + 1, @cury],
      [@curx, @cury - 1],
      [@curx, @cury + 1]
    ]
  end

  def draw_board
    display = "\n  #{ruler}\n"
    set_markers
    @board.each_with_index do |row, index|
      display += "#{index % 10} #{Array(row).map(&:to_s).join} #{index % 10}\n"
    end
    display += "  #{ruler}\n"
    puts display
  end

  def set_markers
    @board[@cury][@curx] = POSITION
    @board[(@size / 2).ceil][(@size / 2).ceil] = STARTPOS
  end

  def ruler
    @ruler ||= (0..@board.first.size - 1).map { |index| index % 10 }.join
  end

  def run_computer!(input)
    computer.run!(input, @test)
    @status = computer.outputs.first
  end

  def computer
    @computer ||= Intcode::Computer.new(@input)
  end
end

Solution.new.run! # true
