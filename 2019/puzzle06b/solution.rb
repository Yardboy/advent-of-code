#!/usr/local/bin/ruby
require '../solution2019'

class Node
  attr_accessor :parent
  attr_reader :orbits, :id

  def initialize(id, parent)
    @id = id
    @parent = parent
    @orbits = 0
  end

  def update_orbits
    @orbits = @parent.orbits + 1
  end

  def ancestors
    parent.nil? ? [] : [parent] + parent.ancestors
  end
end

class Tree
  attr_reader :nodes

  def initialize
    @nodes = {}
  end

  def add_node(parent_id, id)
    @nodes[parent_id] ||= Node.new(parent_id, nil)
    if @nodes[id]
      @nodes[id].parent = @nodes[parent_id]
    else
      @nodes[id] = Node.new(id, @nodes[parent_id])
    end
  end

  def orbits
    @nodes.values.map(&:orbits).sum
  end

  def update_orbits
    parent = @nodes['COM']
    update_children(parent)
  end

  def between(id1, id2)
    if @nodes[id1].ancestors.include?(@nodes[id2])
      @nodes[id1].ancestors.index(@nodes[id2]) + 1
    else
      transfer(id1, id2)
    end
  end

  private

  def transfer(id1, id2)
    transfer = (@nodes[id1].ancestors & @nodes[id2].ancestors).first.id
    from = between(id1, transfer)
    to = between(id2, transfer)
    from + to
  end

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
    build_tree
    @answer = @tree.between('YOU', 'SAN') - 2
  end

  def build_tree
    @input.each { |node_id, parent_id| @tree.add_node(node_id, parent_id) }
    @tree.update_orbits
  end

  # override
  def read_input
    super
    @input = @input.map { |row| row.split(')') }
  end
end

Solution.new.run! # true
