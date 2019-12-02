#!/usr/local/bin/ruby

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end

  def initialize
    @input_lines = 0
    @input = []
    @guards = {}
  end

  def run!
    read_input #:test
    count_minutes
    guard = find_sleepiest_guard
    minute = find_sleepiest_minute_for_guard(guard)

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{guard.to_i * minute}"
  end

  private

  def find_sleepiest_minute_for_guard(key)
    @guards[key].each_with_index.max.last
  end

  def find_sleepiest_guard
    @guards.map { |k, v| [k, v.sum] }.sort_by(&:last).last.first
  end

  def count_minutes
    guard = start = nil
    @input.each do |text|
      date, time, action, key = parse_data(text)
      time = time.to_i
      case action.downcase
      when 'guard'
        guard = key
        @guards[guard] ||= [0] * 60
      when 'falls'
        start = time
      when 'wakes'
        (start..(time - 1)).each { |i| @guards[guard][i] += 1}
        start = nil
      else
        raise UnknownActionError
      end
    end
  end

  def parse_data(text)
    text.gsub(/[\[\]\#\:]/, '').split(' ')
  end

  def read_input type = nil
    if type == :test
      read_test_input
    else
      File.open('input.txt', 'r') do |f|
        f.each_line do |line|
          @input << line
          @input_lines += 1
        end
      end
    end
    @input = @input.sort
  end

  def read_test_input
    # raise NoTestInputError
    @input = [
      '[1518-11-01 00:00] Guard #10 begins shift',
      '[1518-11-01 00:05] falls asleep',
      '[1518-11-01 00:25] wakes up',
      '[1518-11-01 00:30] falls asleep',
      '[1518-11-01 00:55] wakes up',
      '[1518-11-01 23:58] Guard #99 begins shift',
      '[1518-11-02 00:40] falls asleep',
      '[1518-11-02 00:50] wakes up',
      '[1518-11-03 00:05] Guard #10 begins shift',
      '[1518-11-03 00:24] falls asleep',
      '[1518-11-03 00:29] wakes up',
      '[1518-11-04 00:02] Guard #99 begins shift',
      '[1518-11-04 00:36] falls asleep',
      '[1518-11-04 00:46] wakes up',
      '[1518-11-05 00:03] Guard #99 begins shift',
      '[1518-11-05 00:45] falls asleep',
      '[1518-11-05 00:55] wakes up'
    ]
  end
end

Solution.new.run!
