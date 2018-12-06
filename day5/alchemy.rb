#!/usr/bin/env ruby

class Unit
	attr_accessor :letter, :left, :right

	def initialize(letter, left)
		@letter = letter
		@left = left
		left.right = self unless left == nil
		@right = nil
	end

	def react
		if @right == nil then
			return nil
		end
		if @letter != @right.letter and @letter.downcase == @right.letter.downcase then
			if @left != nil then
				if @right.right == nil then
					@left.right = nil
					return @left
				end
				@left.right = @right.right
				@right.right.left = @left
				return @right.right
			else
				@right.right.left = nil
				return @right.right
			end
		end
		@right
	end

	def get_left
		return @left.get_left unless @left == nil
		return self
	end

	def count(i=0)
		i += 1
		return i if @right == nil
		return @right.count(i)
	end
end
	

best = nil
best_count = 99999999
('a'..'z').each do |letter|
	compound = nil
	start = nil
	File.open('input') do |f|
		f.each_char do |c|
			unless c.downcase == letter then
				compound = Unit.new(c, compound) unless c[/\W/]
				start = compound if start == nil
			end
		end
	end

	last_count = 0
	count = 1
	while last_count != count do
		last_count = count
		cur = start

		while cur.right != nil do
			cur = cur.react
		end

		while cur.left != nil do
			cur = cur.left
		end

		start = cur
		count = 1
		while cur.right != nil do
			count += 1
			cur = cur.right
		end
	end
	puts "#{letter} - #{count}"
	if count < best_count then
		best = letter
		best_count = count
	end
end
puts "=============="
puts "#{best} - #{best_count}"
