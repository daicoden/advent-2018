class Unit
  attr_reader :attack, :location, :type
  attr_accessor :hitpoints

  def initialize(type, location)
    @hitpoints = 200
    @attack = 3
    @type = type
    @location = location
  end

  def target
    type == 'E' ? 'G' : 'E'
  end

  def alive?
    @hitpoints > 0
  end

  def perform_attack(unit, map)
    unit.hitpoints -= attack
    unless unit.alive?
      map[unit.location.x][unit.location.y] = '.'
    end
  end
end

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
  def to_s
    "(#{x},#{y})"
  end

  def ==(other)
    other.x == x && other.y == y
  end
end

$elves = []
$goblins = []

def around(point)
  Enumerator.new(4) do |rator|

    rator << Point.new(point.x, point.y - 1)
    rator << Point.new(point.x - 1, point.y)
    rator << Point.new(point.x + 1, point.y)
    rator << Point.new(point.x, point.y + 1)
  end
end

def visited?(state, point)
  state[point.x] ||= []
  state[point.x][point.y]
end

def blocked?(map, point)
  if point.x < 0 || point.y < 0 || point.x > map[0].length || point.y > map.length
    return true
  end

  if map[point.x][point.y] == '#'
    return true
  end
end

def at_path(map, location, unit)
  if location.x < 0 || location.y < 0 || location.x > map[0].length || location.y > map.length
    return :blocked
  end

  if map[location.x][location.y] == '#'
    return :blocked
  end

  if map[location.x][location.y] == unit.target
    return :target
  end

  if map[location.x][location.y] == unit.type
    return :blocked
  end

  :open
end

def breadth_search(map, unit)
  goal_reached = false
  all_blocked = false
  paths = [[unit.location]]
  visited = []

  found_paths = []

  until goal_reached || all_blocked
    all_blocked = true
    new_paths = []
    until paths.empty?
      current_path = paths.shift
      around(current_path.last).each do |neighbor|
        if visited?(visited, neighbor)
          next
        end

        path = at_path(map, neighbor, unit)
        if path == :blocked
          next
        elsif path == :target
          found_paths << current_path + [neighbor]
          goal_reached = true
        end

        all_blocked = false

        visited[neighbor.x][neighbor.y] = true
        new_paths << current_path + [neighbor]
      end
    end

    paths = new_paths
  end

  found_paths
end

units = []

def parse_input(lines)
  state = []
  lines.each_with_index do |row, i|
    row.split("").each_with_index do |column, j|
      state[j] ||= []
      if column == 'E'
        $elves << Unit.new('E', Point.new(j, i))
      elsif column == 'G'
        $goblins << Unit.new('G', Point.new(j, i))
      end
      state[j][i] = column
    end
  end
  state
end

lines = File.read("test-input.txt").split("\n")
map = parse_input(lines)


units = $elves + $goblins


def attack(unit, paths, map)
  if unit.target == 'G'
    to_attack = paths.map do |path|
      puts "#{path[1]}"
      $goblins.find do |g|
        g.location == path[1]
      end
    end
  else
    to_attack = paths.map do |path|
      $elves.find {|e| e.location == path[1]}
    end
  end
  to_attack.sort_by { |u| -u.hitpoints }
  unit.perform_attack(to_attack[0], map)
end

def move(map, unit, path)
  map[unit.location.x][unit.location.y] = '.'
  map[path[1].x][path[1].y] = unit.type
  unit.location.x = path[1].x
  unit.location.y = path[1].y
end

def turn(units, map, turn_count)
  units.sort_by {|u| [u.location.y, u.location.x]}

  units.each do |unit|
    paths = breadth_search(map, unit)
    if paths.size == 0
      # blocked, don't move
    else
      if paths[0].size == 2
        attack(unit, paths, map)
      else
        move(map, unit, paths[0])
      end
    end

  end

  map
end

def print_map(state)
  max_y = state.size
  max_x = state[0].size
  max_y.times do |y|
    max_x.times do |x|
      print state[x][y]
    end
    print("\n")
  end
end

print_map(map)

turn_count = 0
3.times do
  if $elves.none?(&:alive?) || $goblins.none?(&:alive?)
    break [map, turn_count]
  end
  turn_count += 1
  map = turn(units, map, turn_count)

  puts ""
  puts "---"
  puts ""
  print_map(map)

  [map, turn_count]
end

