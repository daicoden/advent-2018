BRANCH = /(\(.*\))/

# start 200x200
complex = []

300.times do |y|
  300.times do |x|
    complex[x] ||= []
    complex[x][y] = '?'
  end
end

def mapout(index, p, complex, string)
  complex[p[0]][p[1]] = 'X'
  to_simulate = [p]
  stack = []
  new_simulations = []
  min_x = complex.size
  max_x = 0

  min_y = complex[0].size
  max_y = 0

  while index < string.size

    to_simulate.each do |point|
      if point[0] > max_x
        max_x = point[0]
      end
      if point[0] < min_x
        min_x = point[0]
      end
      if point[1] > max_y
        max_y = point[1]
      end
      if point[1] < min_y
        min_y = point[1]
      end

      case string[index]
      when 'N'
        complex[point[0]][point[1] - 1] = '-'
        complex[point[0]][point[1] - 2] = '.'
        point[1] -= 2
      when 'E'
        complex[point[0] + 1][point[1]] = '|'
        complex[point[0] + 2][point[1]] = '.'
        point[0] += 2
      when 'S'
        complex[point[0]][point[1] + 1] = '-'
        complex[point[0]][point[1] + 2] = '.'
        point[1] += 2
      when 'W'
        complex[point[0] - 1][point[1]] = '|'
        complex[point[0] - 2][point[1]] = '.'
        point[0] -= 2
      when '('
        stack.push(point.dup)
        break
      when ')'
        stack.pop
        to_simulate = new_simulations
        new_simulations = []
        break
      when '|'
        new_simulations << point.dup
        point[0] = stack[-1][0]
        point[1] = stack[-1][1]
      else
        raise "Don't know #{string[index]}"
      end
    end

    index += 1
  end

  [(min_x - 1)..(max_x + 1), (min_y - 1)..(max_y + 1)]
end


def around(point)
  Enumerator.new(4) do |rator|

    rator << [[point[0], point[1] - 1], [0, -1]]
    rator << [[point[0] - 1, point[1]], [-1, 0]]
    rator << [[point[0] + 1, point[1]], [1, 0]]
    rator << [[point[0], point[1] + 1], [0, 1]]
  end
end

def visited?(state, point)
  state[point[0]] ||= []
  state[point[0]][point[1]]
end

def at_path(map, location)

  if location[0] < 0 || location[1] < 0 || location[0] > map[0].length || location[1] > map.length
    return :blocked
  end

  if map[location[0]][location[1]] == '#'
    return :blocked
  end

  if map[location[0]][location[1]] == '?'
    return :blocked
  end


  :open
end

def breadth_search(map, point, target)
  goal_reached = false
  all_blocked = false
  paths = [[point.dup]]
  visited = []

  found_paths = []

  until goal_reached || all_blocked
    all_blocked = true
    new_paths = []
    until paths.empty?
      current_path = paths.shift
      around(current_path.last).each do |neighbor, adjustment|
        with_adjustment = [neighbor[0] + adjustment[0], neighbor[1] + adjustment[1]]
        if visited?(visited, with_adjustment)
          next
        end

        path = at_path(map, neighbor)
        if path == :blocked
          next
        end

        if target == with_adjustment
          found_paths << current_path + [neighbor]
          goal_reached = true
        end

        all_blocked = false

        visited[with_adjustment[0]][with_adjustment[1]] = true unless goal_reached

        new_paths << current_path + [with_adjustment]
      end
    end

    paths = new_paths
  end

  found_paths.min_by {|found_paths| found_paths.size}
end


def print_complex(state, range_x, range_y)
  range_y.each do |y|
    range_x.each do |x|
      if state[x][y] == '?'
        print '#'
      else
        print state[x][y]
      end
    end
    print("\n")
  end
end

regex = File.read("test3-input.txt").chomp

puts regex[1...-1]

start = [150, 150]
bounds = mapout(0, start.dup, complex, regex[1...-1])

print_complex(complex, bounds[0], bounds[1])


found_paths = []
bounds[1].each do |y|
  bounds[0].each do |x|
    if complex[x][y] == '.'
      found_paths << breadth_search(complex, start.dup, [x, y])
    end
  end
end

found_paths.each do |path|
#  puts path.inspect
end

max_path = found_paths.max_by {|x| x.size}

puts max_path.size - 1