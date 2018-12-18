def around(location, max_x, max_y)
  Enumerator.new do |y|
    [[-1, 0],
     [-1, -1],
     [0, -1],
     [1, -1],
     [1, 0],
     [1, 1],
     [0, 1],
     [-1, 1]].each do |adjustment|
      new_loc = [location[0] + adjustment[0], location[1] + adjustment[1]]
      if new_loc[0] < 0 || new_loc[0] >= max_x || new_loc[1] < 0 || new_loc[1] >= max_y
        next
      end

      y << new_loc


    end
  end
end

def process_open(state, location, max_x, max_y)
  tree_count = 0
  around(location, max_x, max_y).each do |loc|

    if state[loc[0]][loc[1]] == '|'
      tree_count += 1
    end
  end
  if tree_count >= 3
    '|'
  else
    '.'
  end
end

def process_trees(state, location, max_x, max_y)
  lumber_count = 0
  around(location, max_x, max_y).each do |loc|
    if state[loc[0]][loc[1]] == '#'
      lumber_count += 1
    end
  end
  if lumber_count >= 3
    '#'
  else
    '|'
  end
end

def process_lumberyard(state, location, max_x, max_y)
  lumber_count = 0
  tree_count = 0
  around(location, max_x, max_y).each do |loc|
    if state[loc[0]][loc[1]] == '#'
      lumber_count += 1
    elsif state[loc[0]][loc[1]] == '|'
      tree_count += 1
    end
  end

  if lumber_count > 0 && tree_count > 0
    '#'
  else
    '.'
  end
end

def next_tick(state)
  new_state = Marshal.load(Marshal.dump(state))
  max_y = state.size
  max_x = state[0].size

  max_y.times do |y|
    max_x.times do |x|
      case state[x][y]
      when '.'
        new_state[x][y] = process_open(state, [x, y], max_x, max_y)
      when '|'
        new_state[x][y] = process_trees(state, [x, y], max_x, max_y)
      when '#'
        new_state[x][y] = process_lumberyard(state, [x, y], max_x, max_y)
      else
        raise "AHH"
      end

    end
  end

  new_state
end

def parse_input(lines)
  state = []
  lines.each_with_index do |row, i|
    row.split("").each_with_index do |column, j|
      state[j] ||= []
      state[j][i] = column
    end
  end
  state
end


def print_tree(state)
  max_y = state.size
  max_x = state[0].size
  max_y.times do |y|
    max_x.times do |x|
      print state[x][y]
    end
    print("\n")
  end
end

def count_tree(state)
  lumber_count = 0
  tree_count = 0

  max_y = state.size
  max_x = state[0].size
  max_y.times do |y|
    max_x.times do |x|
      if state[x][y] == '|'
        tree_count += 1
      elsif state[x][y] == '#'
        lumber_count += 1
      end
    end
  end

  [tree_count, lumber_count]

end



input = File.read("day18-input.txt").split("\n")
puts input.join("\n")
puts ""
puts "---"
puts ""

the_state = parse_input(input)


print_tree(the_state)

cycle_found = false
1000000000.times do |tick|
  the_state = next_tick(the_state)

  tree, lumber = count_tree(the_state)
  puts "Iter #{tick} #{tree * lumber}"
  if tree * lumber == 179922 && cycle_found
    puts "Cycle found #{tick}"
    break
  end
  if tree * lumber == 179922
    cycle_found = true
  end
end

puts ""
puts "---"
puts ""

print_tree the_state

tree, lumber = count_tree the_state

puts tree * lumber


# Not sure why -1
# ((1000000000 - 536) % 28 + 536 - 1)
