#!/usr/local/bin/ruby
require '../solution2019'

Chemical = Struct.new(:key, :quantity)

class Reaction
  attr_reader :produces, :inputs, :balance

  def initialize(data)
    @inputs = parse_line(data).flatten.map { |item| parse_item(item) }
    @produces = @inputs.pop
    @balance = 0
  end

  def servings
    (balance.abs / quantity.to_f).ceil
  end

  def demand!(integer)
    @balance -= integer
  end

  def supply!
    @balance += (servings * quantity)
  end

  def key
    produces.key
  end

  def quantity
    produces.quantity
  end

  def requires_ore?
    inputs.all? { |input| input[:key] == 'ORE' }
  end

  def parse_line(line)
    inputs, output = line.split('=>')
    [inputs.split(','), output]
  end

  def parse_item(item)
    item = item.strip.split(' ')
    Chemical.new(item[1], item[0].to_i)
  end
end

class Solution < Solution2019
  private

  def additional_setup
    @lower = @upper = 1
    @ore = 10**12
  end

  def process_input
    find_upper_bound
    @answer = (@lower..@upper).bsearch { |i| demand_fuel(i) > @ore } - 1
  end

  def find_upper_bound
    until demand_fuel(@upper) > @ore
      @lower = @upper
      @upper = @lower * 10
    end
  end

  def demand_fuel(quantity)
    @answer = 0
    reactions['FUEL'].demand!(quantity)
    process_demands until all_demands_require_ore?
    process_demands(false)
    @answer
  end

  def process_demands(exclude_ores = true)
    demands.each do |reaction|
      next if exclude_ores && reaction.requires_ore?

      supply_reaction(reaction)
    end
  end

  def supply_reaction(reaction)
    reaction.inputs.each do |input|
      if reaction.requires_ore?
        @answer += (reaction.servings * input.quantity)
      else
        reactions[input.key].demand!(reaction.servings * input.quantity)
      end
    end
    reaction.supply!
  end

  def all_demands_require_ore?
    demands.all?(&:requires_ore?)
  end

  def demands
    reactions.values.select { |reaction| reaction.balance.negative? }
  end

  def reactions
    @reactions ||= @input.each_with_object({}) do |line, hsh|
      reaction = Reaction.new(line)
      hsh[reaction.key] = reaction
    end
  end
end

Solution.new.run! # true
