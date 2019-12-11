#!/usr/local/bin/ruby

require '../solution2019'

class Solution < Solution2019
  private

  # override
  def additional_setup
    @width = 25
    @height = 6
  end

  def process_input
    min = nil
    summary.each do |hsh|
      if min.nil? || hsh[0] < min
        min = hsh[0]
        @answer = hsh[1] * hsh[2]
      end
    end
  end

  def summary
    @summary ||= layers.map do |layer|
      layer.flatten.sort.chunk { |data| data }.each_with_object({}) do |(pixel, pixels), hsh|
        hsh[pixel] = pixels.size
      end
    end
  end

  def layers
    @layers ||= @input.each_slice(@width).to_a.each_slice(@height).to_a
  end

  # override
  def read_input
    super
    @input = @input.first.split('').map(&:to_i)
  end
end

Solution.new.run! # true
