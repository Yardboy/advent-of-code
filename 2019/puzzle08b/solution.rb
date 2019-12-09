#!/usr/local/bin/ruby

require '../solution2019'

class Solution < Solution2019
  private

  def process_input
    @width = 25
    @height = 6
    @image = Array.new(@height){Array.new(@width)}
    find_top_pixels
    set_answer
  end

  def set_answer
    @answer = "\n" + @image.map { |row| row.join('') }.join("\n")
  end

  def find_top_pixels
    @width.times do |w|
      @height.times do |h|
        find_top_pixel(h, w)
      end
    end
  end

  def find_top_pixel(hval, wval)
    layers.each do |layer|
      next if layer[hval][wval] == 2

      @image[hval][wval] = colors[layer[hval][wval].to_s] if @image[hval][wval].nil?
    end
  end

  def colors
    {
      '0' => ' ',
      '1' => '@'
    }
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
