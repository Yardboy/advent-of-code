#!/usr/local/bin/ruby
require '../solution2019'

class Moon
  attr_reader :posx, :posy, :posz, :velx, :vely, :velz

  def initialize(input)
    @posx = @posy = @posz = @velx = @vely = @velz = 0
    process_input(input)
  end

  def process_input(input)
    input.delete('><').split(',').map { |coord| coord.strip.split('=') }.each do |pos, value|
      change_position(pos, value.to_i)
    end
  end

  def total_energy
    kinetic * potential
  end

  def apply_gravity(other_moon)
    axes.each do |axis|
      next if position(axis) == other_moon.position(axis)

      [self, other_moon].sort_by { |moon| moon.position(axis) }.each_with_index do |moon, index|
        moon.change_velocity(axis, index.zero? ? 1 : -1)
      end
    end
  end

  def apply_velocity
    axes.each do |axis|
      change_position(axis, velocity(axis))
    end
  end

  def display(mthd)
    "#{mthd.to_s[0..2]}=<#{axes.map { |axis| "#{axis}=#{format('% 3i', send(mthd, axis))}" }.join(', ')}>"
  end

  def position(axis)
    send("pos#{axis}")
  end

  def velocity(axis)
    send("vel#{axis}")
  end

  protected

  def kinetic
    energy(:velocity)
  end

  def potential
    energy(:position)
  end

  def energy(mthd)
    axes.map { |axis| send(mthd, axis).abs }.sum
  end

  def change_position(axis, value)
    instance_variable_set(:"@pos#{axis}", position(axis) + value)
  end

  def change_velocity(axis, value)
    instance_variable_set(:"@vel#{axis}", velocity(axis) + value)
  end

  def axes
    %w[x y z]
  end
end

class Solution < Solution2019
  private

  # override
  def additional_setup
    @moons = @input.map { |input| Moon.new(input) }
    @steps = 1000
  end

  def process_input
    @steps.times do
      apply_gravity
      apply_velocity
    end
    @answer = @moons.map(&:total_energy).sum
  end

  def apply_velocity
    @moons.each(&:apply_velocity)
  end

  def apply_gravity
    @moons.combination(2).each { |moon1, moon2| moon1.apply_gravity(moon2) }
  end
end

Solution.new.run! # true
