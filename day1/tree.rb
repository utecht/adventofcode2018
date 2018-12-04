#!/usr/bin/env ruby

class BTree
  class TNode
    attr_accessor :value, :left, :right

    def initialize(value)
      @value = value
      @left = nil
      @right = nil
    end
  end

  def initialize(initial_value)
    @root = TNode.new(initial_value)
  end

  def add(value, node=@root)
    return false if node.value == value
    if value > node.value then
      if node.left != nil then
        return add(value, node.left)
      end
      node.left = TNode.new(value)
      return true
    else
      if node.right != nil then
        return add(value, node.right)
      end
      node.right = TNode.new(value)
      return true
    end
  end

  def stringify(node=@root)
    left = '#'
    unless node.left == nil
      left = stringify(node.left)
    end
    right = '#'
    unless node.right == nil
      right = stringify(node.right)
    end
    "#{node.value} -> (#{left} | #{right})"
  end
end
