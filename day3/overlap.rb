#!/usr/bin/env ruby


class Claim
  attr_reader :id, :left, :top, :width, :height

  def initialize(line)
    @id, @left, @top, @width, @height = line.scan(/\d+/).map { |i| i.to_i }
  end

  def get_ranges
    ranges = Array.new
    (@top...@top+@height).each do |y|
      ranges.push((@left + (y * 1000)...@left + @width + (y * 1000)))
    end
    ranges
  end

  def to_s
    "##{id} @ #{left},#{top}: #{width}x#{height}"
  end
end

claims = Array.new
File.open('input').each do |line|
  claims.push(Claim.new(line))
end

cloth = Array.new(1000*1000, nil)
clean_claims = Hash.new
claims.each do |claim|
  clean_claims[claim.id] = claim
end
while clean_claims.keys.length > 1 do
  clean_claims.values.each do |claim|
    claim.get_ranges.each do |range|
      range.each do |spot|
        id = cloth[spot]
        if id == nil or id == claim.id then
          cloth[spot] = claim.id
        else
          clean_claims = clean_claims.reject { |k,v| k == id or k == claim.id}
        end
      end
    end
  end
  puts "=================#{clean_claims.keys.length}==================="
end
puts clean_claims
