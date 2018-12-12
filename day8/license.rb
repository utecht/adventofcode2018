#!/usr/bin/env ruby

class Node
  attr_reader :parent, :children_count, :metadata_count
  attr_accessor :children, :metadata

  def initialize(parent, num_children, num_metadata)
    @parent = parent
    @children_count = num_children
    @metadata_count = num_metadata
    @children = []
    @value = nil
  end

  def value
    return @value unless @value.nil?
    if @children.empty?
      @value = @metadata.reduce(0, :+)
    else
      @value = 0
      @metadata.each do |md|
        if (md - 1) < @children.length
          @value += @children[md - 1].value
        end
      end
    end
    @value
  end
end

nodes = []
data = File.read("input").split.map { |x| x.to_i }
current_node = Node.new(nil, data.shift, data.shift)
nodes.push(current_node)
until data.empty?
  if current_node.children.length == current_node.children_count
    current_node.metadata = data.shift(current_node.metadata_count)
    current_node = current_node.parent
  else
    current_node = Node.new(current_node, data.shift, data.shift)
    current_node.parent.children.push(current_node)
    nodes.push(current_node)
  end
end

total = 0
nodes.map {|node| total += node.metadata.reduce(0, :+)}
puts "total: #{total}"
puts "value: #{nodes.first.value}"
