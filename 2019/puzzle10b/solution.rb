#!/usr/local/bin/ruby
require '../solution2019'

class Solution < Solution2019
  private

  def process_input
    @answer = [nil, 0]
    @slopes = {}
    @asteroids.each do |asteroid|
      @slopes = {}
      determine_slopes(asteroid)
      @answer = [asteroid, @slopes.size, @slopes] if @slopes.size > @answer[1]
    end
    sort_slopes
    @answer = vaporized[199]
    @answer = @answer[0] * 100 + @answer[1]
  end

  def vaporized
    vaporized = []
    until @slopes.all? { |_, asteroids| asteroids.empty? } do
      @slopes.each do |_, asteroids|
        vaporized << asteroids.shift unless asteroids.empty?
      end
    end
    vaporized
  end

  def sort_slopes
    @slopes = @answer[2]
    @slopes.each { |_, asteroids| asteroids.reverse! if before_station?(asteroids.first) }
    @slopes = @slopes.to_a.sort_by { |(slope, quadrant), _| [quadrant, slope] }.reverse
  end

  def before_station?(asteroid)
    asteroid[1] < @answer.first[1] || (asteroid[1] == @answer.first[1] && asteroid[0] < @answer.first[0])
  end

  def determine_slopes(asteroid)
    (@asteroids - [asteroid]).each do |station|
      slope = slope(station, asteroid)
      quadrant = quadrants[signs(station, asteroid)]
      @slopes[[slope, quadrant]] ||= []
      @slopes[[slope, quadrant]] << station
    end
  end

  def slope(station, asteroid)
    ((station[1] - asteroid[1]).to_f / (station[0] - asteroid[0]).to_f * -1.0).round(5)
  end

  def signs(station, asteroid)
    "#{sign_of(station[1] - asteroid[1])}#{sign_of(station[0] - asteroid[0])}"
  end

  def sign_of(value)
    '++-'[value <=> 0]
  end

  def quadrants
    {
      '--' => 0,
      '+-' => 1,
      '++' => 2,
      '-+' => 3
    }
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
