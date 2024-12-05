#!/usr/local/bin/ruby

require '../solution2024.rb'

class Solution < Solution2024
  private

  # override
  def additional_setup
    @answer = 0
    @rules = @input.select { |line| line.include?('|') }.map { |line| line.split('|').map(&:to_i) }
    @updates = @input.select { |line| line.include?(',') }.map { |line| [line.split(',').map(&:to_i), true] }
  end

  def process_input
    process_rules
    count_correct_updates
  end

  def count_correct_updates
    @updates.select { |update| !update.last }.each do |update|
      update = sort_update(update.first)
      @answer += update[update.size / 2]
    end
  end

  def sort_update(update)
    update.dup.each do |page|
      (update.index(page) - 1).downto(0).each do |i|
        if @rules.include?([page, update[i]])
          update.insert(i, update.delete(page))
        end
      end
    end
    update
  end

  def process_rules
    @rules.each do |early, late|
      @updates.each_with_index do |update, index|
        update = update.first
        if update.include?(early) && update.include?(late)
          if update.index(early) > update.index(late)
            @updates[index][1] = false
          end
        end
      end
    end
  end
end

Solution.new.run! testmode: false
# 7380
