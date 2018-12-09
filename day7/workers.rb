#!/usr/bin/env ruby

class Instruction
	attr_reader :step, :prereqs, :ready

	def initialize(name)
		@prereqs = Array.new
		@step = name
		@ready = true
	end

	def add_prereq(prereq)
		@prereqs.push(prereq) unless @prereqs.include?(prereq)
	end

	def drop_prereq(prereq)
		@prereqs.delete(prereq)
	end

	def started
		@ready = false
	end

end

class Worker
	attr_reader :finish_time
	attr_accessor :job

	def initialize
		@job = '.'
		@finish_time = 0
	end	

	def add_job(name, cur_time)
		duration = 60 + (name.ord - 'A'.ord) + 1
		@finish_time = cur_time + duration
		@job = name
	end

	def to_s
		"#{@job} - #{@finish_time}"
	end
end

@steps = Hash.new
File.open('input').each do |line|
	before = line[/Step (\w) must be finished before step (\w) can begin./, 1]
	step = line[/Step (\w) must be finished before step (\w) can begin./, 2]
	@steps[step] = Instruction.new(step) unless @steps.keys.include?(step)
	@steps[before] = Instruction.new(before) unless @steps.keys.include?(before)
	@steps[step].add_prereq(before)
end

@order = Array.new
def get_next
	ready = Array.new
	@steps.values.each do |step|
		ready.push(step.step) if step.prereqs.empty? and step.ready
	end
	ready.sort.first
end

def finish(letter)
	@order << letter
	@steps.delete(letter)
	@steps.values.each {|step| step.drop_prereq(letter)}
end

def next_worker(workers, second)
	workers.each do |worker|
		return worker unless worker.finish_time > second
	end	
end

second = 0
workers = Array.new
5.times { workers << Worker.new }
while true
	workers.each do |worker|
		if worker.finish_time == second then
			finish(worker.job)
			worker.job = '.'
		end
	end
	while true
		todo = get_next
		worker = next_worker(workers, second)
		break if worker == nil
		break if todo == nil
		puts "====workers====="
		puts workers
		worker.add_job(todo, second)
		@steps[todo].started
	end
	puts "#{second}  -  #{workers[0].job}  -  #{workers[1].job} -  #{workers[2].job}  -  #{workers[3].job}  -  #{workers[4].job} -> #{@order.join('')}"
	any_working = false
	if get_next == nil then
		workers.each do |worker|
			any_working = true if worker.finish_time > second
		end
	end
	break unless any_working
	second += 1
end

