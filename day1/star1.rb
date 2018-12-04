#!/usr/bin/env ruby

counter = 0
File.open("input").each do |line|
  line.strip!()
  if line != "" then
    counter += Integer(line)
  end
end
puts counter
