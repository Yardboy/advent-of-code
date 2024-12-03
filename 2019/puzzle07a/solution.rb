#!/usr/local/bin/ruby
require '../solution2019'
require '../intcode'

class Solution < Solution2019
  private

  # override
  def additional_setup
    @answer = [0, nil]
  end

  def process_input
    (1234..43_210).each do |settings|
      value = run_amps(settings)
      @answer = [value, settings] if value > @answer[0]
    end
    @answer = @answer[0] # comment out if you want to see the phase setting
  end

  def run_amps(settings)
    settings = format('%05i', settings).chars.map(&:to_i)
    return 0 if settings.uniq.size != 5 || settings.any? { |n| n > 4 }

    input2 = 0
    settings.each do |phase|
      input2 = Intcode::Computer.new(@input.first).run!([phase, input2], @test).last
    end
    input2
  end
end

Solution.new.run! # true
