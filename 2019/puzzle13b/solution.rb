#!/usr/local/bin/ruby
require '../solution2019'
require '../intcode'

class Board
  attr_reader :score, :ball, :paddle

  def initialize(instructions)
    @tiles = []
    @score = 0
    @ball = @paddle = nil
    @last_ball = []
    take_turn(instructions)
  end

  def clear?
    @tiles.flatten.none? { |tile| tile == 2 }
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

  def hdir
    if @last_ball
      @ball[0] - @last_ball[0]
    else
      0
    end
  end

  def vdir
    if @last_ball
      (@ball[1] - @last_ball[1]).positive? ? 1 : -1
    else
      0
    end
  end

  def on_paddle?
    ball == vertex
  end

  def on_slope?
    vdir == 1 && slope_of_ball == hdir.to_f
  end

  private

  def char(type)
    { '0' => '.', '1' => '#', '2' => '█', '3' => '_', '4' => 'O' }[type.to_s]
  end

  def slope_of_ball
    ((vertex[1] - ball[1]).to_f / (vertex[0] - ball[0]).to_f)
  end

  def vertex
    [@paddle[0], @paddle[1] - 1]
  end

  def update_board(posx, posy, type)
    @tiles[posy][posx] = type
    update_ball(posx, posy) if type == 4
    update_paddle(posx, posy) if type == 3
  end

  def update_ball(posx, posy)
    @last_ball = @ball
    @ball = [posx, posy]
  end

  def update_paddle(posx, posy)
    @paddle = [posx, posy]
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
    @turns = 0
    @balls = []
    @input = @input.first
    @debug = false
    update_input
  end

  def process_input
    run_computer!(nil)
    board.draw
    play_game until board.clear? || computer.done?
    @answer = board.score
  end

  def play_game
    @turns += 1
    show_turn_data if @debug
    take_turn
    board.draw
    sleep(0.0075)
  end

  def show_turn_data
    puts "Turn: #{@turns}, " + %w[hdir vdir ball paddle on_paddle? on_slope?].map { |mthd|
      "#{mthd}: #{board.send(mthd)}"
    }.join(', ') + ", Action: #{action}"
  end

  def action
    if no_action?
      0
    elsif board.hdir.zero?
      move_paddle_to_ball
    else
      board.hdir
    end
  end

  def move_paddle_to_ball
    (board.ball[0] - board.paddle[0]).positive? ? 1 : -1
  end

  def no_action?
    board.on_paddle? || board.on_slope? || (board.ball[0] - board.paddle[0]).zero?
  end

  def take_turn
    computer.clear_output!
    run_computer!(action)
    board.take_turn(computer.outputs)
  end

  def update_input
    @input = @input.split(',').map(&:to_i)
    @input[0] = 2
    @input = @input.join(',')
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
