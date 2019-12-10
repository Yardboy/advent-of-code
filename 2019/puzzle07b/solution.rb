#!/usr/local/bin/ruby
require '../solution2019'
require '../intcode'

class Solution < Solution2019
  private

  def process_input
    @answer = 0
    phase = []
    (56_789..98_765).each do |values|
      value = run_amps(values)
      if value > @answer
        @answer = value
        phase = values
      end
    end
    @answer = [@answer, phase]
  end

  def run_amps(values)
    phases = format('%05i', values).split('').map(&:to_i)
    return 0 if phases.uniq.size != 5 || phases.any? { |n| n < 5 }

    clear_amps
    feedback_loop(first_run(phases))
  end

  def clear_amps
    @amps = []
    5.times { @amps << Intcode::Computer.new(@input) }
  end

  def first_run(phases)
    signal = 0
    phases.each_with_index do |phase, index|
      signal = @amps[index].run!([phase, signal], @test)
    end
    signal
  end

  def feedback_loop(signal)
    while @amps.any? { |amp| amp.state != 'done' }
      signal = @amps.first.restart!(signal)
      @amps.unshift(@amps.pop)
    end
    signal
  end

  # override
  def read_input
    super
    @input = @input.first.split(',').map(&:to_i)
  end
end

Solution.new.run! # true
