#!/usr/bin/env ruby

class Instruction
	attr_reader :step, :prereqs

	def initialize(name)
		@prereqs = Array.new
		@step = name
	end

	def add_prereq(prereq)
		@prereqs.push(prereq) unless @prereqs.include?(prereq)
	end

	def drop_prereq(prereq)
		@prereqs.delete(prereq)
	end

end

steps = Hash.new
File.open('input').each do |line|
	before = line[/Step (\w) must be finished before step (\w) can begin./, 1]
	step = line[/Step (\w) must be finished before step (\w) can begin./, 2]
	steps[step] = Instruction.new(step) unless steps.keys.include?(step)
	steps[before] = Instruction.new(before) unless steps.keys.include?(before)
	steps[step].add_prereq(before)
end

order = Array.new
until steps.empty? do
	ready = Array.new
	steps.values.each do |step|
		ready.push(step.step) if step.prereqs.empty?
	end
	todo = ready.sort.first
	order << todo
	steps.delete(todo)
	steps.values.each {|step| step.drop_prereq(todo)}
end

puts order.join('')
