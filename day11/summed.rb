#!/usr/bin/env ruby

def level(x, y, serial)
  rack_id = x + 10
  level = rack_id * y
  level += serial
  level *= rack_id
  # pull out hundreths
  s = level.to_s
  if s.length >= 3 then
    level = s[-3].to_i
  else
    level = 0
  end
  level -= 5
  level
end


def pos(x, y)
  x -= 1
  y -= 1
  x + (y * 300)
end

grid = Array.new
(1..300).each do |y|
  (1..300).each do |x|
    value = level(x, y, 9005)
    value += grid[pos(x - 1, y)] unless x == 1
    value += grid[pos(x, y - 1)] unless y == 1
    value -= grid[pos(x - 1, y - 1)] unless y == 1 or x == 1
    grid << value
  end
end

def get_area(grid, x, y, size)
  x -= 1
  y -= 1
  a = (x > 0 and y > 0) ? grid[pos(x, y)] : 0
  b = y > 0 ? grid[pos(x+size, y)] : 0
  c = x > 0 ? grid[pos(x, y+size)] : 0
  d = grid[pos(x+size, y+size)]
  d - b - c + a
end

spot = nil
max = -999999
size = nil
(1..300).each do |y|
  (1..300).each do |x|
    max_width = x > y ? 301 - x : 301 - y
    (1..max_width).each do |s|
      value = get_area(grid, x, y, s)
      if value > max then
        size = s
        spot = [x,y]
        max = value 
        puts "#{spot[0]},#{spot[1]},#{size} - #{max}"
      end
    end
  end
end

puts "#{spot[0]},#{spot[1]},#{size} - #{max}"
