

class Node
  attr_reader :children, :metadata

  def initialize()
    @children = []
    @metadata = []
  end

  def add_child(child)
    @children << child
  end


  def add_metadata(metadata)
    @metadata << metadata
  end
end



def parse(array, idx)
  index = idx
  child_node_count = array[index]
  metadata_count = array[index + 1]

  index += 2
  node = Node.new
  child_node_count.times do |i|
    child, index = parse(array, index)
    node.add_child(child)
  end

  metadata_count.times do  |i|
    node.add_metadata(array[index])
    index += 1
  end

  [node, index]
end


def sum_metadata(node)
  node.metadata.inject(0, &:+) + node.children.inject(0) { |total, child| total + sum_metadata(child)}
end

characters = File.read("day8-input.txt").split(" ").map(&:to_i)

root_node, index = parse(characters, 0)


def checksum_node(node)
  if node.children.size == 0
    return node.metadata.inject(0, &:+)
  end

  sum = 0

  node.metadata.each do |index|
    if index == 0
      next
    else
      child = node.children[index - 1]
      sum += checksum_node(child) if child
    end
  end


  sum

end


puts checksum_node(root_node)


