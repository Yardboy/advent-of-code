#!/usr/local/bin/ruby
require '../solution2019'

Asteroid = Struct.new(:x, :y) do
  def before?(station)
    y < station.y || (y == station.y && x < station.x)
  end
end

Path = Struct.new(:station, :asteroid) do
  def key
    [slope, quadrant]
  end

  private

  def deltax
    station.x - asteroid.x
  end

  def deltay
    station.y - asteroid.y
  end

  def slope
    (deltay.to_f / deltax.to_f * -1.0).round(5)
  end

  def signs
    [deltay, deltax].map { |value| '++-'[value <=> 0] }.join('')
  end

  def quadrant
    {
      '--' => 0,
      '+-' => 1,
      '++' => 2,
      '-+' => 3
    }[signs]
  end
end

class Solution < Solution2019
  private

  # override
  def additional_setup
    @asteroids = []
    @input.each_with_index do |line, row|
      line.split('').each_with_index do |char, col|
        @asteroids << Asteroid.new(col, row) if char == '#'
      end
    end
  end

  def process_input
    @answer = find_best_station[2]
  end

  def find_best_station
    result = [nil, [], 0]
    @asteroids.each do |asteroid|
      paths = determine_paths(asteroid)
      result = [asteroid, paths, paths.size] if paths.size > result[2]
    end
    result
  end

  def determine_paths(asteroid)
    (@asteroids - [asteroid]).each_with_object({}) do |station, hsh|
      path = Path.new(station, asteroid)
      hsh[path.key] ||= []
      hsh[path.key] << station
    end
  end
end

Solution.new.run! # true
