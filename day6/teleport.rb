#!/usr/bin/env ruby

class Point
	attr_reader :x, :y

	def initialize(x, y)
		@x = x
		@y = y
	end

	def distance(other)
		(other.x - @x).abs + (other.y - @y).abs
	end

	def to_s
		"#{@x}, #{@y}"
	end
end

targets = Array.new
max_x = 0
max_y = 0
File.open('input').each do |line|
	x, y = line.scan(/\d+/).map { |n| n.to_i }
	targets.push(Point.new(x, y))
	max_x = x if x > max_x
	max_y = y if y > max_y
end
	
puts "#{max_x} #{max_y}"

def closest(point, points)
	distances = Hash.new
	points.each { |p| distances[p] = p.distance(point) }
	if distances.values.count(distances.values.min) == 1 then
		return distances.key(distances.values.min)
	else
		return nil
	end
end

invalid = Array.new
points = Hash.new(0)
row = Array.new

letters =* ('a'..'z')

close_points = 0
(0..max_y).each do |y|
	(0..max_x).each do |x|
		point = Point.new(x, y)
		p = closest(point, targets)
		if p == nil then
			row.push('.')
		else
			if p.distance(point) == 0 then
				row.push(letters[targets.index(p) % letters.length].upcase)
			else
				row.push(letters[targets.index(p) % letters.length])
			end
		end
		if x == 0 or y == 0 or x == max_x or y == max_y then
			invalid.push(p) unless invalid.include?(p)
		end
		points[closest(point, targets)] += 1

#	calculate problem 2
		total_distance = 0
		targets.each do |t|
			total_distance += t.distance(point)
		end
		if total_distance < 10000 then
			close_points += 1
			row[-1] = "\e[31m#{row.last}\e[0m"
		end
	end
	puts row.join('')
	row = Array.new
end

max_value = 0
biggest = nil
points.each do |k,v|
	if v > max_value and k != nil and not invalid.include?(k) then
		max_value = v
		biggest = k
	end
end

puts "#{biggest} #{letters[targets.index(biggest) % letters.length].upcase}"
puts max_value

puts "problem 2: #{close_points}"
