#! /usr/bin/ruby

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input_lines = 0
    @input = []
    @players = []
    @marbles = 0
    @circle = [0, 2, 1]
    @current_marble = 2
    @current_player = 0
  end

  def run!
    get_input #:test
    @input = @input.split(' ')
    @input[0].to_i.times { @players << 0 }
    @current_player = @players.size - 1
    @marbles = (3..@input[6].to_i).to_a

    until @marbles.empty?
      next_player
      play_next_marble
    end

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@players.max}"
  end

  private

  def play_next_marble
    marble = @marbles.shift
    if special?(marble)
      play_special(marble)
    else
      play_regular(marble)
    end
  end

  def play_regular(marble)
    pos1 = cw(index_of_current, 1)
    pos2 = cw(pos1, 1)
    if pos2.zero?
      @circle << marble
    else
      @circle.insert(pos2, marble)
    end
    @current_marble = marble
  end

  def play_special(marble)
    @players[@current_player] += marble
    pos1 = cc(index_of_current, 7)
    pos2 = cw(pos1, 1)
    @current_marble = @circle[pos2]
    @players[@current_player] += @circle.delete_at(pos1)
  end

  def index_of_current
    @circle.index(@current_marble)
  end

  def cw(start, steps)
    steps.times do |i|
      start += 1
      start = 0 if start == @circle.size
    end
    start
  end

  def cc(start, steps)
    steps.times do |i|
      start -= 1
      start = @circle.size - 1 if start < 0
    end
    start
  end

  def special?(marble)
    marble % 23 == 0
  end
  
  def next_player
    @current_player += 1
    @current_player = 0 if @current_player == @players.size
  end

  def get_input type = nil
    if type == :test
      get_test_input
    else
      @input = File.read('input.txt').chomp
    end
  end

  def get_test_input
    # raise NoTestInputError
    #@input = "9 players; last marble is worth 25 points"
    #@input = "10 players; last marble is worth 1618 points"
    #@input = "13 players; last marble is worth 7999 points"
    #@input = "17 players; last marble is worth 1104 points"
    #@input = "21 players; last marble is worth 6111 points"
    @input = "30 players; last marble is worth 5807 points"
  end
end

Solution.new.run!
