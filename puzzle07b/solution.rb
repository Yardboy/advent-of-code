#! /usr/bin/ruby

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input_lines = 0
    @input = []
    @data = {}
    @completed = []
    @workers = [[nil, 0]] * 5
    @default_step_duration = 60
  end

  def run!
    get_input #:test
    get_data

    until all_steps_completed? do
      @timer ||= -1
      @timer += 1
      clear_completed_workers
      start_new_workers
      work_the_steps
      #display # uncomment to see work pattern
    end

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@timer}"
  end

  private

  def all_steps_completed?
    @data.empty? && @workers.map(&:first).compact.empty?
  end

  def work_the_steps
    @workers.each { |w| w[1] -= 1 }
  end

  def start_time_for(step)
    ('A'..'Z').to_a.index(step) + 1 + @default_step_duration
  end

  def start_new_workers
    @workers.each_with_index do |w, index|
      if w.first.nil?
        step = @data.select { |step, prereqs| prereqs.empty? }.map(&:to_a).flatten.sort.first
        break if step.nil?
        @workers[index] = [step, start_time_for(step)]
        @data.delete(step)
      end
    end
  end

  def clear_completed_workers
    @workers.each_with_index do |w, index|
      if w.last == 0 && w.first
        @completed << w.first
        @data.each do |step, prereqs|
          prereqs.delete(w.first)
          @data[step] = prereqs
        end
        @workers[index] = [nil, 0]
      end
    end
  end

  def get_data
    @input.each do |prereq, step|
      @data[prereq] ||= []
      @data[step] ||= []
      @data[step] << prereq
    end
  end

  def display
    text = [@timer]
    @workers.each do |w|
      text << (w.first.nil? ? '.' : w.first)
    end
    text << @completed.join
    puts text.join('     ')
  end

  def get_input type = nil
    if type == :test
      get_test_input
    else
      File.open('input.txt', 'r') do |f|
        f.each_line do |line|
          @input << line.scan(/\s.\s/).map(&:strip)
          @input_lines += 1
        end
      end
    end
  end

  def get_test_input
    # raise NoTestInputError
    @input = [
      ['C', 'A'],
      ['C', 'F'],
      ['A', 'B'],
      ['A', 'D'],
      ['B', 'E'],
      ['D', 'E'],
      ['F', 'E']
    ]
  end
end

Solution.new.run!
