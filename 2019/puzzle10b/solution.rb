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

  def process_input
    @answer = [nil, 0]
    @station, @paths, @answer = find_best_station
    @answer = vaporized[199]
    @answer = @answer[0] * 100 + @answer[1]
  end

  def vaporized
    sort_paths
    vaporized = []
    until @paths.all? { |_, asteroids| asteroids.empty? } do
      @paths.each do |_, asteroids|
        vaporized << asteroids.shift unless asteroids.empty?
      end
    end
    vaporized
  end

  def find_best_station
    result = [nil, [], 0]
    @asteroids.each do |asteroid|
      paths = determine_paths(asteroid)
      result = [asteroid, paths, paths.size] if paths.size > result[2]
    end
    result
  end

  def sort_paths
    @paths.each { |_, asteroids| asteroids.reverse! if asteroids.first.before?(@station) }
    @paths = @paths.to_a.sort_by { |(slope, quadrant), _| [quadrant, slope] }.reverse
  end

  def determine_paths(asteroid)
    (@asteroids - [asteroid]).each_with_object({}) do |station, hsh|
      path = Path.new(station, asteroid)
      hsh[path.key] ||= []
      hsh[path.key] << station
    end
  end

  # override
  def read_input
    super
    @asteroids = []
    @input.each_with_index do |line, row|
      line.split('').each_with_index do |char, col|
        @asteroids << Asteroid.new(col, row) if char == '#'
      end
    end
  end
end

Solution.new.run! # true
