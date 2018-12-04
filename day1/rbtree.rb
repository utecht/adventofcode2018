#!/usr/bin/env ruby

class RBTree
  class TNode
    attr_accessor :value, :left, :right, :color, :parent

    def initialize(value, parent, color)
      @value = value
      @parent = parent
      @left = nil
      @right = nil
      @color = color
    end
  end

  def initialize(initial_value)
    @root = TNode.new(initial_value, nil, :black)
  end

  def left_rotate(x)
    y = x.right
    x.right = y.left
    if y.left != nil then
      y.left.parent = x
    end
    y.parent = x.parent

    if x.parent == nil
      @root = y
    else
      if x == x.parent.left then
        x.parent.left = y
      else
        x.parent.right = y
      end
    end
    y.left = x
    x.parent = y
  end

  def right_rotate(x)
    y = x.left
    x.left = y.right
    if y.right != nil then
      y.right.parent = x
    end
    y.parent = x.parent

    if x.parent == nil
      @root = y
    else
      if x == x.parent.right then
        x.parent.right = y
      else
        x.parent.left = y
      end
    end
    y.right = x
    x.parent = y
  end

  def rebalance(x)
    while x != @root and x.parent.color == :red do
      if x.parent == x.parent.parent.left then
        y = x.parent.parent.right
        if y != nil and y.color == :red then
          x.parent.color = :black
          y.color = :black
          x.parent.parent.color = :red
          x = x.parent.parent
        else
          if x == x.parent.right then
            x = x.parent
            left_rotate(x)
          end
          x.parent.color = :black
          x.parent.parent.color = :red
          right_rotate(x.parent.parent)
        end
      else
        y = x.parent.parent.left
        if y != nil and y.color == :red then
          x.parent.color = :black
          y.color = :black
          x.parent.parent.color = :red
          x = x.parent.parent
        else
          if x == x.parent.left then
            x = x.parent
            right_rotate(x)
          end
          x.parent.color = :black
          x.parent.parent.color = :red
          left_rotate(x.parent.parent)
        end
        @root.color = :black
      end
    end
  end

  def add(value, node=@root)
    return false if node.value == value
    if value < node.value then
      if node.left != nil then
        return add(value, node.left)
      end
      node.left = TNode.new(value, node, :red)
      rebalance(node.left)
      return true
    else
      if node.right != nil then
        return add(value, node.right)
      end
      node.right = TNode.new(value, node, :red)
      rebalance(node.right)
      return true
    end
  end

  def stringify(node=@root)
    color = 31
    unless node.color == :black
      color = 34
    end
    left = '#'
    unless node.left == nil
      left = stringify(node.left)
    end
    right = '#'
    unless node.right == nil
      right = stringify(node.right)
    end
    "\e[#{color}m#{node.value}\e[0m -> (#{left} | #{right})"
  end
end

=begin
t = RBTree.new(11)
puts t.stringify
t.add(2)
puts t.stringify
t.add(14)
puts t.stringify
t.add(1)
puts t.stringify
t.add(7)
puts t.stringify
t.add(5)
puts t.stringify
t.add(8)
puts t.stringify
t.add(14)
puts t.stringify
t.add(15)
puts t.stringify

puts "here comes the rotations"
t.add(4)
puts t.stringify
=end
