#!/usr/bin/env ruby

require 'date'

class Guard
  attr_reader :id

  class Rest
    def initialize(start, wake)
      @start = start
      @wake = wake
    end

    def duration
      @wake - @start
    end
    
    def range
      (@start...@wake)
    end
  end

  class Shift
    attr_reader :rests

    def initialize(date)
      @date = date
      @rests = Array.new
    end

    def add_rest(start, wake)
      @rests.append(Rest.new(start, wake))
    end

    def sleep_duration
      total = 0
      @rests.each do |rest|
        total += rest.duration
      end
      total
    end
  end

  def initialize(id)
    @id = id
    @shifts = Array.new
  end

  def add_shift(date)
    @shifts.push(Shift.new(date)).last
  end

  def total_sleep
    total = 0
    @shifts.each do |shift|
      total += shift.sleep_duration
    end
    total
  end

  def most_asleep_minute
    minutes = Hash.new(0)
    @shifts.each do |shift|
      shift.rests.each do |rest|
        rest.range.each do |min|
          minutes[min] += 1
        end
      end
    end
    minutes
  end
end

class Event
  attr_reader :timestamp, :event, :id

  def initialize(line)
    @timestamp = DateTime.parse(line[/\[(.+)\]/, 1])
    if line[/begins/] then
      @event = :start
      @id = line[/#(\d+)/, 1]
    end
    @event = :sleep if line[/falls/]
    @event = :wake if line[/wakes/]
  end
  
  def <=>(other)
    @timestamp <=> other.timestamp  
  end
end

events = File.open('input').map { |line| Event.new(line) }.sort
events.sort!
guards = Array.new
guard = nil
shift = nil
start = nil
events.each do |event|
  if event.event == :start then
    guard = nil
    guards.each do |g|
      guard = g if g.id == event.id
    end
    guard = guards.push(Guard.new(event.id)).last if guard == nil
    shift = guard.add_shift(event.timestamp)
  end

  if event.event == :sleep then
    start = event.timestamp.min
  end

  if event.event == :wake then
    shift.add_rest(start, event.timestamp.min)
  end
end

guards = guards.sort! { |x,y| x.total_sleep <=> y.total_sleep }
id = guards.last.id
min, t = guards.last.most_asleep_minute.max_by { |k,v| v }
puts "problem 1 = #{id.to_i * min.to_i}"

max_times = 0
min = nil
guard_id = nil
guards.each do |guard|
  m, t = guard.most_asleep_minute.max_by { |k,v| v }
  if t != nil and t > max_times then
    guard_id = guard.id
    max_times = t
    min = m
  end
end
puts "problem 2 = #{guard_id.to_i * min.to_i}"
