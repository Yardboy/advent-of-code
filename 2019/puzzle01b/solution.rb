#!/usr/local/bin/ruby

require '../solution2019'

class Solution < Solution2019
  private

  # override
  def additional_setup
    @answer = 0
  end

  def process_input
    @input.each do |mass|
      @answer += adjusted_fuel(calculate_fuel(mass))
    end
  end

  def adjusted_fuel(fuel)
    total = fuel
    while fuel >= 0
      fuel = calculate_fuel(fuel)
      total += fuel if fuel.positive?
    end
    total
  end

  def calculate_fuel(mass)
    (mass.to_i / 3.0).floor - 2
  end
end

Solution.new.run! # true
