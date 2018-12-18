require 'set'

def addr(reg, a, b, c)
  reg[c] = reg[a] + reg[b]
  reg
end

def addi(reg, a, b, c)
  reg[c] = reg[a] + b
  reg
end

def mulr(reg, a, b, c)
  reg[c] = reg[a] * reg[b]
  reg
end

def muli(reg, a, b, c)
  reg[c] = reg[a] * b
  reg

end

def banr(reg, a, b, c)
  reg[c] = reg[a] & reg[b]
  reg
end

def bani(reg, a, b, c)
  reg[c] = reg[a] & b
  reg
end

def borr(reg, a, b, c)
  reg[c] = reg[a] | reg[b]
  reg
end

def bori(reg, a, b, c)
  reg[c] = reg[a] | b
  reg
end

def setr(reg, a, b, c)
  reg[c] = reg[a]
  reg
end

def seti(reg, a, b, c)
  reg[c] = a
  reg

end

def gtir(reg, a, b, c)
  reg[c] = a > reg[b] ? 1 : 0
  reg
end

def gtri(reg, a, b, c)
  reg[c] = reg[a] > b ? 1 : 0
  reg
end

def gtrr(reg, a, b, c)
  reg[c] = reg[a] > reg[b] ? 1 : 0
  reg
end

def eqir(reg, a, b, c)
  reg[c] = (a == reg[b] ? 1 : 0)
  reg
end

def eqri(reg, a, b, c)
  reg[c] = (reg[a] == b ? 1 : 0)
  reg
end

def eqrr(reg, a, b, c)
  reg[c] = (reg[a] == reg[b] ? 1 : 0)
  reg
end

opcodes = [
    method(:addr),
    method(:addi),
    method(:mulr),
    method(:muli),
    method(:banr),
    method(:bani),
    method(:borr),
    method(:bori),
    method(:setr),
    method(:seti),
    method(:gtir),
    method(:gtri),
    method(:gtrr),
    method(:eqir),
    method(:eqri),
    method(:eqrr)
]

input = File.read("day16-input.txt").split("\n")

map = Hash.new {|k, v| k[v] = Set.new(opcodes)}

def parse_tests(lines)
  tests = []
  instructions = []

  until lines.empty?
    line = lines.shift
    if line.empty?
      next
    end

    if line.start_with?("Before")
      before = eval line.split("Before: ")[1]
      test = lines.shift.split(" ").map(&:to_i)
      after = eval lines.shift.split("After: ")[1]
      tests << [before, test, after]
      next
    end


    instructions << line.split(" ").map(&:to_i)
  end

  [tests, instructions]
end

tests, instructions = parse_tests(input)

three_or_more = 0

tests.each do |before, instruction, after|
  matching_opcodes = opcodes.find_all do |handler|
    handler.call(before.dup, instruction[1], instruction[2], instruction[3]) == after
  end

  map[instruction[0]] &= Set.new(matching_opcodes)

  nonmatching_op = opcodes - matching_opcodes
  nonmatching_op.each do |nonmatching|
    map[instruction[0]].delete(nonmatching)
  end

  if matching_opcodes.size >= 3
    three_or_more += 1
  end
end

while map.any? {|value, handler| handler.size > 1}
  discovered_handlers = Set.new
  map.each do |value, handler|
    if handler.size == 1
      discovered_handlers << handler.to_a[0]
    end
  end

  map.each do |value, handler|
    if handler.size > 1
      map[value] -= discovered_handlers
    end
  end


end


final_map = {}
map.each do |value, handler|
  if handler.size > 1
    puts "not gonna work"
    raise "boom"
  end

  final_map[value] = handler.to_a[0]
end

register = [0, 0, 0, 0]
instructions.each do |instruction|
  final_map[instruction[0]].call(register, instruction[1], instruction[2], instruction[3])
end
puts register[0]

