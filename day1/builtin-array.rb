#!/usr/bin/env ruby

counter = 0
previous_values = Array.new
values = Array.new

File.open("input").each do |line|
  line.strip!()
  if line != "" then
    values.push(Integer(line))
  end
end

while true do
  values.each do |value|
    counter += value
    if previous_values.include?(counter) then
      puts counter
      exit
    end
    previous_values.push(counter)
  end
end
