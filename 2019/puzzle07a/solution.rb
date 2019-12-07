#!/usr/local/bin/ruby
require '../solution2019'
require '../intcode'

class Solution < Solution2019
  private

  def process_input
    @answer = 0
    phase = []
    (1234..43_210).each do |settings|
      value = run_amps(settings)
      if value > @answer
        @answer = value
        phase = settings
      end
    end
    @answer = [@answer, phase]
  end

  def run_amps(settings)
    settings = format('%05i', settings).split('').map(&:to_i)
    return 0 if settings.uniq.size != 5 || settings.any? { |n| n > 4 }

    input2 = 0
    settings.each do |phase|
      input2 = Intcode.new.run!([phase, input2], @test)
    end
    input2
  end
end

Solution.new.run! # true
