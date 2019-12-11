#!/usr/local/bin/ruby
require '../solution2019'

class Node
  attr_accessor :parent
  attr_reader :orbits

  def initialize(parent)
    @parent = parent
    @orbits = 0
  end

  def update_orbits
    @orbits = @parent.orbits + 1
  end
end

class Tree
  def initialize
    @nodes = {}
  end

  def add_node(parent_id, id)
    @nodes[parent_id] ||= Node.new(nil)
    if @nodes[id]
      @nodes[id].parent = @nodes[parent_id]
    else
      @nodes[id] = Node.new(@nodes[parent_id])
    end
  end

  def orbits
    @nodes.values.map(&:orbits).sum
  end

  def update_orbits
    parent = @nodes['COM']
    update_children(parent)
  end

  private

  def update_children(parent)
    children_for_node(parent).each do |_id, child|
      child.update_orbits
      update_children(child)
    end
  end

  def children_for_node(parent)
    @nodes.select { |_id, node| node.parent == parent }
  end
end

class Solution < Solution2019
  private

  # override
  def additional_setup
    @tree = Tree.new
  end

  def process_input
    @input.each { |node_id, parent_id| @tree.add_node(node_id, parent_id) }
    @tree.update_orbits
    @answer = @tree.orbits
  end

  # override
  def read_input
    super
    @input = @input.map { |row| row.split(')') }
  end
end

Solution.new.run! # true
