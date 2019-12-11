#!/usr/local/bin/ruby
require '../solution2019'
require '../intcode'

class Solution < Solution2019
  private

  def process_input
    @answer = Intcode::Computer.new(@input.first).run!(2, @test).last
  end
end

Solution.new.run! # true
