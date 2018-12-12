#!/usr/bin/env ruby

class Cell
  attr_reader :x, :y

  def initialize(x, y, serial)
    @x = x
    @y = y
    @serial = serial
    @level = nil
  end

  def level
    return @level unless @level == nil
    rack_id = @x + 10
    @level = rack_id * @y
    @level += @serial
    @level *= rack_id
    # pull out hundreths
    s = @level.to_s
    if s.length >= 3 then
      @level = s[-3].to_i
    else
      @level = 0
    end
    @level -= 5
    @level
  end
end

grid = Hash.new
(1..300).each do |x|
  (1..300).each do |y|
    grid[[x,y]] = Cell.new(x, y, 9005)
  end
end

def calc_grid(x, y, size, grid)
  total = 0
  (x..x+size-1).each do |x|
    (y..y+size-1).each do |y|
      total += grid[[x, y]].level
    end
  end
  total
end

best = nil
max = -999999999
size = 0

thread_count = 20
mutex = Mutex.new
thread_count.times.map do |i|
  Thread.new do
    my_grid = nil
    mutex.synchronize do
      my_grid = Marshal.load(Marshal.dump(grid))
    end
    (1..300).each do |x|
      next unless x % thread_count == i
      (1..300).each do |y|
        x_width = 301 - x
        y_width = 301 - y
        max_width = x_width < y_width ? x_width : y_width
        (1..max_width).each do |s|
          v = calc_grid(x, y, s, my_grid)
          mutex.synchronize do
            if v > max then
              best = [x, y]
              max = v
              size = s
              puts "x#{best[0]}, y#{best[1]}, size#{size} -> #{max}"
            end
          end
        end
      end
    end
  end
end.each(&:join)

puts "x#{best[0]}, y#{best[1]}, size#{size} -> #{max}"
