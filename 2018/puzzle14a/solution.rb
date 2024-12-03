#!/usr/local/bin/ruby

class Recipe
  attr_accessor :next, :prev
  attr_reader :value

  def initialize(value)
    @value = value
    @next = nil
    @prev = nil
  end
end

class RecipeList
  attr_reader :count

  def initialize
    @head = nil
    @tail = nil
    @count = 0
  end

  def add_recipe(value)
    new_recipe = Recipe.new(value)
    if @head
      new_recipe.prev = @tail
      @tail = @tail.next = new_recipe
    else
      @tail = @head = new_recipe
    end
    @count += 1
    new_recipe
  end

  def move(recipe, steps)
    steps.abs.times do
      recipe = if steps.positive?
                 recipe.next || @head
               else
                 recipe.prev || @tail
               end
    end
    recipe
  end

  def to_s
    nodes = [@head]
    nodes << nodes.last.next while nodes.last.next
    puts nodes.map(&:value).join(' ')
  end
end

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end

  def initialize
    @input = []
    @answer = ''
    @target = nil
    @list = RecipeList.new
  end

  def run!
    read_input # :test

    @elf1 = add_recipe(3)
    @elf2 = add_recipe(7)

    add_new_recipes while @list.count < @input + 10

    10.times do
      @target = @target.next
      @answer += @target.value.to_s
    end

    puts "Answer: #{@answer}"
  end

  private

  def add_new_recipes
    new_recipe_values.each do |new_recipe|
      add_recipe(new_recipe)
    end
    @elf1 = @list.move(@elf1, 1 + @elf1.value)
    @elf2 = @list.move(@elf2, 1 + @elf2.value)
  end

  def new_recipe_values
    (@elf1.value + @elf2.value).to_s.chars.map(&:to_i)
  end

  def add_recipe(value)
    recipe = @list.add_recipe(value)
    @target = recipe if @list.count == @input
    recipe
  end

  def read_input(type = nil)
    if type == :test
      read_test_input
    else
      @input = 306_281
    end
  end

  def read_test_input
    # raise NoTestInputError
    # @input = 9
    # @input = 5
    # @input = 18
    @input = 2018
  end
end

Solution.new.run!
