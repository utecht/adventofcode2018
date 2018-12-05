#!/usr/bin/env ruby


class Chksum
  attr_reader :two_count, :three_count

  def initialize
    @two_count = 0
    @three_count = 0
    File.open("input").each do |line|
      count_letters(line)
    end
  end

  def count_letters(word)
    letters = Hash.new(0)
    word.split('').each do |letter|
      letters[letter] += 1
    end
    @two_count += 1 if letters.values.include?(2)
    @three_count += 1 if letters.values.include?(3)
  end
end

c = Chksum.new
puts c.two_count * c.three_count
