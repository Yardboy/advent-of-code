#!/usr/local/bin/ruby
require '../solution2019'
require '../intcode'

class Solution < Solution2019
  private

  def process_input
    @answer = Intcode::Computer.new.run!(5, @test)
  end
end

Solution.new.run! # true
