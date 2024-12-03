#!/usr/local/bin/ruby

class Marble
  attr_accessor :next, :prev
  attr_reader :value

  def initialize(value)
    @value = value
    @next = nil
    @prev = nil
  end
end

class Circle
  attr_reader :current

  def initialize
    @head = nil
    @tail = nil
    @current = nil
  end

  def insert_after_current(value)
    if @head
      old_next = @current.next
      @current.next = Marble.new(value)
      @current.next.next = old_next
      @current.next.prev = @current
      old_next.prev = @current.next if old_next
      @tail = @current.next if current_is_tail?
    else
      @current = Marble.new(value)
      @tail = @head = @current
    end
  end

  def current_is_tail?
    @current == @tail
  end

  def move(steps)
    steps.abs.times do
      @current = if steps.positive?
                   @current.next || @head
                 else
                   @current.prev || @tail
                 end
    end
  end

  def remove_current
    @current.prev.next = @current.next
    @current.next.prev = @current.prev
    @current = @current.next
  end

  def to_s
    nodes = [@head]
    nodes << nodes.last.next while nodes.last.next
    puts nodes.map { |node|
      if node == @current
        "(#{node.prev ? node.prev.value : '-'}:#{node.value}:#{node.next ? node.next.value : '-'})"
      else
        "#{node.prev ? node.prev.value : '-'}:#{node.value}:#{node.next ? node.next.value : '-'}"
      end
    }.join(' ')
  end
end

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end

  def initialize
    @input_lines = 0
    @input = []
    @players = []
    @last_marble = 0
    @circle = Circle.new
    @circle.insert_after_current(0)
    @current_marble = 2
    @current_player = 0
  end

  def run!
    read_input # :test
    @input = @input.split
    @input[0].to_i.times { @players << 0 }
    @current_player = @players.size - 1

    i = 1
    while i <= @input[6].to_i * 100
      play_marble(i)
      i += 1
    end

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@players.max}"
  end

  private

  def play_marble(val)
    next_player
    if special?(val)
      play_special(val)
    else
      play_regular(val)
    end
    # puts @circle.to_s
  end

  def play_regular(val)
    @circle.move(1)
    @circle.insert_after_current(val)
    @circle.move(1)
  end

  def play_special(val)
    @players[@current_player] += val
    @circle.move(-7)
    @players[@current_player] += @circle.current.value
    @circle.remove_current
  end

  def special?(marble)
    !marble.zero? && (marble % 23).zero?
  end

  def next_player
    @current_player += 1
    @current_player = 0 if @current_player == @players.size
  end

  def read_input(type = nil)
    if type == :test
      read_test_input
    else
      @input = File.read('input.txt').chomp
    end
  end

  def read_test_input
    # raise NoTestInputError
    @input = '9 players; last marble is worth 25 points'
    # @input = "10 players; last marble is worth 1618 points"
    # @input = "13 players; last marble is worth 7999 points"
    # @input = "17 players; last marble is worth 1104 points"
    # @input = "21 players; last marble is worth 6111 points"
    # @input = "30 players; last marble is worth 5807 points"
  end
end

Solution.new.run!
