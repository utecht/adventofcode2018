#!/usr/bin/env ruby

require_relative 'rbtree'

counter = 0
previous_values = RBTree.new(0)
values = Array.new

File.open("input").each do |line|
  line.strip!()
  if line != "" then
    values.push(Integer(line))
  end
end

while true do
  values.each do |value|
    counter += value
    if previous_values.add(counter) == false then
      puts counter
      exit
    end
  end
end
