#!/usr/local/bin/ruby
require '../solution2019'

class Solution < Solution2019
  private

  def process_input
    @answer = [nil, 0]
    @asteroids.each do |asteroid|
      @slopes = {}
      determine_slopes(asteroid)
      @answer = [asteroid, @slopes.size] if @slopes.size > @answer[1]
    end
  end

  def determine_slopes(asteroid)
    (@asteroids - [asteroid]).each do |station|
      slope = slope(station, asteroid)
      signs = signs(station, asteroid)
      @slopes[[slope, signs]] ||= []
      @slopes[[slope, signs]] << station
    end
  end

  def slope(station, asteroid)
    ((station[0] - asteroid[0]).to_f / (station[1] - asteroid[1]).to_f).round(5)
  end

  def signs(station, asteroid)
    "#{sign_of(station[0] - asteroid[0])}#{sign_of(station[1] - asteroid[1])}"
  end

  def sign_of(value)
    '++-'[value <=> 0]
  end

  # override
  def read_input
    super
    @asteroids = []
    @input.each_with_index do |line, row|
      line.split('').each_with_index do |char, col|
        @asteroids << [col, row] if char == '#'
      end
    end
  end
end

Solution.new.run! # true
