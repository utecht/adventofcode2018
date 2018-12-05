#!/usr/bin/env ruby


class Strdiff
  def initialize
    @boxes = Array.new
    File.open("input").each do |line|
      @boxes.push(line)
    end
  end

  def distance(a, b)
    dist = 0
    (0..a.length).each do |i|
      dist += 1 unless a[i] == b[i]
    end
    dist
  end

  def closest_strings
    closest_a = ''
    closest_b = ''
    min_dist = 9999
    @boxes.each do | box |
      @boxes.each do | box2 |
        unless box == box2 then
          d = distance(box, box2)
          if d < min_dist then
            closest_a = box
            closest_b = box2
            min_dist = d
          end
        end
      end
    end
    puts min_dist
    puts closest_a
    puts closest_b
  end
end

s = Strdiff.new
s.closest_strings
