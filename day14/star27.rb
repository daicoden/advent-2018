
$size = 0

class Node
  attr_accessor :next, :previous
  attr_reader   :value

  def initialize(value)
    @value = value
    @next  = self
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

goal = 77201

while goal + 10  > $size
  (first_elf.value + second_elf.value).to_s.each_char do |next_value|
    last = last.insert_after(next_value.to_i)
  end

  (first_elf.value + 1).times do |step|
    first_elf = first_elf.next
  end

  (second_elf.value + 1).times do |step|
    second_elf = second_elf.next
  end
end

puts goal
puts goal + 10
puts $size

10.times do |step|
  last = last.previous
end

str = ''
if goal + 10 + 1 == $size
  last = last.previous
end

puts $size

10.times do |step|
  last = last.next
  str += last.value.to_s
end

puts str
