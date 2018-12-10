#!/usr/bin/env ruby

require 'oily_png'

class Point
  attr_reader :x, :y

  def initialize(x, y, dx, dy)
    @x = x
    @y = y
    @dx = dx
    @dy = dy
  end

  def step
    @x = @x + @dx
    @y = @y + @dy
  end

  def unstep
    @x = @x - @dx
    @y = @y - @dy
  end
end

points = Array.new
File.open('input').each do |line|
  x, y, dx, dy = line.scan(/-?\d+/).map { |x| x.to_i }
  points << Point.new(x, y, dx, dy)
end

def min_max(points)
  min_x = 0
  max_x = 0
  min_y = 0
  max_y = 0
  points.each do |p|
    min_x = p.x unless p.x > min_x
    min_y = p.y unless p.y > min_y
    max_x = p.x unless p.x < max_x
    max_y = p.y unless p.y < max_y
  end
  return min_x, min_y, max_x, max_y
end

def size(points)
  min_x, min_y, max_x, max_y = min_max(points)
  offset_x = min_x.abs
  offset_y = min_y.abs
  x_size = max_x + offset_x + 1
  y_size = max_y + offset_y + 1

  x_size * y_size
end

@num = 0
def print(points)
  min_x, min_y, max_x, max_y = min_max(points)
  offset_x = min_x.abs
  offset_y = min_y.abs
  x_size = max_x + offset_x + 1
  y_size = max_y + offset_y + 1

  #puts "=========="
  puts "#{x_size} x #{y_size}"
  puts x_size * y_size
  png = ChunkyPNG::Image.new(x_size, y_size, ChunkyPNG::Color::TRANSPARENT)
  points.each do |p|
    png[p.x + offset_x, p.y + offset_y] = ChunkyPNG::Color('black @ 1.0')
  end
  @num += 1
  png.save("message#{@num}.png", :interlace => true)
end

def in_a_row(numbers, threshold=5)
  numbers.sort!
  streak = 0
  last = 0
  numbers.each do |n|
    if n == last + 1 then
      streak += 1
      return true unless streak < threshold
    else
      streak = 0
    end
    last = n
  end
  false
end

def detect_line(points)
  xs = points.collect {|p| p.x}
  ys = points.collect {|p| p.y}
  in_a_row(xs) or in_a_row(ys)
end

size = 9999999999999999
while true do
  points.map { |p| p.step }
  if size(points) > size
    points.map { |p| p.unstep }
    print(points)
    exit
  else
    size = size(points)
  end
end
