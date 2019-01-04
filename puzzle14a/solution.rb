#! /usr/bin/ruby

class Recipe
  attr_accessor :next, :prev
  attr_reader :value

  def initialize(value)
    @value = value
    @next = nil
    @prev = nil
  end
end

class Batch
  attr_reader :current, :head, :tail

  def initialize
    @head = nil
    @tail = nil
    @current = nil
  end

  def insert_after_current(value)
    if @head
      old_next = @current.next
      @current.next = Recipe.new(value)
      @current.next.next = old_next
      @current.next.prev = @current
      old_next.prev = @current.next if old_next
      @tail = @current.next if current_is_tail?
    else
      @current = Recipe.new(value)
      @tail = @head = @current
    end
  end

  def current_is_tail?
    @current == @tail
  end

  def move(steps)
    steps.abs.times do
      if steps.positive?
        @current = @current.next || @head
      else
        @current = @current.prev || @tail
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
    while nodes.last.next
      nodes << nodes.last.next
    end
    puts nodes.map { |node| node.value }.join(' ')
  end
end

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input_lines = 0
    @input = []
    @recipes = 0
    @target = nil
    @batch = Batch.new
  end

  def run!
    get_input #:test

    add_recipe(3)
    @elf1 = @batch.current
    add_recipe(7)
    @elf2 = @batch.current

    while @recipes < @input + 10
      add_new_recipes
    end

    @answer = ''
    10.times do
      @target = @target.next
      @answer += @target.value.to_s
    end

    puts "Input Lines: #{@input_lines}"
    puts "Answer: #{@answer}"
  end

  private

  def add_new_recipes
    (@elf1.value + @elf2.value).to_s.split('').map(&:to_i).each do |new_recipe|
      add_recipe(new_recipe)
    end
    (1 + @elf1.value).times do
      @elf1 = @elf1.next || @batch.head
    end
    (1 + @elf2.value).times do
      @elf2 = @elf2.next || @batch.head
    end
  end

  def add_recipe(value)
    @batch.insert_after_current(value)
    @batch.move(1)
    @recipes += 1
    if @recipes == @input
      @target = @batch.current
    end
  end

  def get_input type = nil
    if type == :test
      get_test_input
    else
      @input = 306281
    end
  end

  def get_test_input
    # raise NoTestInputError
    #@input = 9
    #@input = 5
    #@input = 18
    @input = 2018
  end
end

Solution.new.run!
