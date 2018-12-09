

class Node
  attr_accessor :next, :previous
  attr_reader   :value

  def initialize(value)
    @value = value
    @next  = self
    @previous = self
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

def print_buf(node)
  print "#{node.value} "
  next_node = node.next

  until next_node == node
    print "#{next_node.value} "
    next_node = next_node.next
  end

  print("\n")

end

def simulate(players, max_count)
  scores = []
  player = 0

  current = Node.new(0)
  head = current

  (1..max_count).each do |marble_value|
    if marble_value % 23 == 0
      scores[player % players] ||= 0
      scores[player % players] += marble_value

      #print_buf(head)
      7.times do
#        puts current.value
        current = current.previous
      end
      scores[player % players] += current.value

      #puts "Removing #{current.value}"
      #puts "#{current.next.next.next.previous.value}"
      current = current.remove_self
    else
      current = current.next.insert_after(marble_value)
    end

    player += 1
  end

  scores
end

result = simulate(419, 7105200)
puts result.inspect
puts result.max
