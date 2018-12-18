$size = 0

class Node
  attr_accessor :next, :previous
  attr_reader :value

  def initialize(value)
    @value = value
    @next = self
    @previous = self
    $size += 1
  end

  def to_s
    "Node with value: #{@value}"
  end

  def insert_after(value)
    next_node = Node.new(value)
    @next.previous = next_node

    next_node.previous = self
    next_node.next = @next
    @next = next_node
    next_node
  end

  def remove_self
    @previous.next = self.next
    @next.previous = previous
    @next
  end
end

first_elf = Node.new(3)
second_elf = first_elf.insert_after(7)
last = second_elf

goal = "077201"

space = goal.to_s.length
start_node = nil

found = false

def value_of(node, size)
  value = ""
  size.times do
    value += node.value.to_s
    node = node.next
  end

  value
end

recipie_count = 0

until found
  (first_elf.value + second_elf.value).to_s.each_char do |next_value|
    last = last.insert_after(next_value.to_i)
    recipie_count += 1
  end

  (first_elf.value + 1).times do |step|
    first_elf = first_elf.next
  end

  (second_elf.value + 1).times do |step|
    second_elf = second_elf.next
  end

  if start_node.nil? && space <= $size
    start_node = last
    space.times do
      start_node = start_node.previous
    end
  elsif start_node
    #puts "looking at #{value_of(start_node, goal.to_s.length)}"
    found = value_of(start_node, goal.to_s.length) == goal.to_s
    start_node = start_node.next
  end

  if recipie_count % 100 == 0
    puts "#{recipie_count}"
  end

end


extra_count = 0
until start_node == last
  extra_count += 1
  start_node = start_node.next
end

puts recipie_count - extra_count
