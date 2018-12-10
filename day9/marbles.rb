#!/usr/bin/env ruby

class Marble
  attr_accessor :left, :right, :value

  def initialize(left, right, value)
    @left = left
    @right = right
    @value = value
  end

  def starting
    @left = self
    @right = self
  end

  def add(value)
    left = @right
    right = @right.right
    new = Marble.new(left, right, value)
    left.right = new
    right.left = new
    new
  end
  
  def score(value)
    remove = @left.left.left.left.left.left.left
    left = remove.left
    right = remove.right
    left.right = right
    right.left = left
    value + remove.value
  end
end

player_count = ARGV[0].to_i
total_marbles = ARGV[1].to_i
players = Array.new(player_count, 0)
cur_player = 0
marbles = Marble.new(nil, nil, 0)
marbles.starting
(1..total_marbles).each do |i|
  players.rotate!
  if i % 23 == 0 then
    players[0] += marbles.score(i)
    marbles = marbles.left.left.left.left.left.left
  else
    marbles = marbles.add(i)
  end
end
puts "#{players.count} players; last marble is worth #{marbles.value} points: high score is #{players.max}"
