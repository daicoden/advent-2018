class Node
  attr_reader :name

  def initialize(name)
    @name = name
    @ready = false
    @prereqs = []
    @completed = false
    @in_progress = false
  end

  def add_prereq(node)
    @prereqs << node
  end

  def ready?
    @prereqs.all?(&:completed?) && !completed? && !in_progress?
  end

  def doit
    @completed = true
    @in_progress = false
  end

  def completed?
    @completed
  end

  def in_progress?
    @in_progress
  end

  def in_progress!
    @in_progress = true
  end
end

work_time = {
    a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8,
    i: 9, j: 10, k: 11, l: 12, m: 13, n: 14, o: 15, p: 16, q: 17, r: 18, s: 19, t: 20, u: 21,
    v: 22, w: 23, x: 24, y: 25, z: 26
}

nodes = Hash.new {|h, v| h[v] = Node.new(v)}

lines = File.read("day7-input.txt").split("\n")

regex = /Step (\w) must be finished before step (\w) can begin./

lines.each do |line|
  if line =~ regex
    nodes[$2].add_prereq(nodes[$1])
  else
    raise "Bad Line #{line}"
  end
end

workers = [5]
step_adjustment = 60
tick = 0

work = Hash.new { |h, v| h[v] = []}


def wrap(node, workers)
  Proc.new do
    workers[0] +=1
    node.doit
  end

end

until nodes.values.all?(&:completed?)
  work[tick].each(&:call)

  while workers[0] > 0 && (node = nodes.values.find_all {|n| n.ready?}.sort_by(&:name).first)
    workers[0] -= 1
    node.in_progress!
    #puts "Assigning worker #{node.name} at #{tick} to finish at #{tick + step_adjustment + work_time[node.name.downcase.to_sym]}"
    work[tick + step_adjustment + work_time[node.name.downcase.to_sym]] << wrap(node, workers)
  end


  tick = tick + 1
end

puts tick - 1

