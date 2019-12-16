#!/usr/local/bin/ruby
require '../solution2019'
require '../intcode'

class Solution < Solution2019
  TURNS = { u: %i[l r], r: %i[u d], d: %i[r l], l: %i[d u] }.freeze

  private

  # override
  def additional_setup
    @posx = @posy = 0
    @panels = {}
    @heading = :u
    @start_color = 0 # start on a black panel
  end

  def process_input
    until computer.done?
      new_color, direction = run_computer(current_color)[-2..-1]
      paint!(new_color)
      turn!(direction)
      move!(1)
    end
    @answer = @panels.size
  end

  def position
    [@posx, @posy]
  end

  def move!(distance)
    case @heading
    when :u
      @posy -= distance
    when :r
      @posx += distance
    when :d
      @posy += distance
    when :l
      @posx -= distance
    end
  end

  def turn!(direction)
    @heading = TURNS[@heading][direction]
  end

  def paint!(color)
    @panels[position] = color if current_color != color
  end

  def current_color
    computer.waiting? ? @panels[position] || 0 : @start_color
  end

  def run_computer(input)
    computer.run!(input)
  end

  def computer
    @computer ||= Intcode::Computer.new(@input.first)
  end
end

Solution.new.run! # true
