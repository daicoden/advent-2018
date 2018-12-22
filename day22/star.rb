require 'pqueue'

CHART = [:rocky, :wet, :narrow]

def print_complex(state, range_x, range_y)
  range_y.each do |y|
    range_x.each do |x|

      if [x, y] == [0, 0]
        print 'M'
        next
      end

      if [x, y] == [range_x.last, range_y.last]
        print 'T'
        next
      end

      case CHART[state[x][y] % 3]
      when :rocky
        print '.'
      when :wet
        print '='
      when :narrow
        print '|'
      end
    end
    print("\n")
  end
end


def fill_map(depth, target, map)
  (0..target[1]).each do |y|
    (0..target[0]).each do |x|
      map[x] ||= []

      geological_index =
          if x == 0 && y == 0
            0
          elsif [x, y] == target
            0
          elsif x == 0
            y * 48271
          elsif y == 0
            x * 16807
          else
            map[x - 1][y] * map[x][y - 1]
          end


      map[x][y] = ((geological_index + depth) % 20183)
    end
  end

end


def calc_sum(map, range_x, range_y)
  sum = 0
  range_y.each do |y|
    range_x.each do |x|
      sum += case CHART[map[x][y] % 3]
             when :rocky
               0
             when :wet
               1
             when :narrow
               2
             else
               throw "What is this #{map[x][y] % 3}"
             end
    end
  end
  sum
end

class CaveSystem
  attr_reader :depth, :target

  def initialize(depth, target)
    @depth = depth
    @target = target
    @values = []
  end

  def value_at(location)
    x = location[0]
    y = location[1]

    if @values[x] && @values[x][y]
      return @values[x][y]
    end

    geological_index =
        if x == 0 && y == 0
          0
        elsif [x, y] == target
          0
        elsif x == 0
          y * 48271
        elsif y == 0
          x * 16807
        else
          value_at([x - 1, y]) * value_at([x, y - 1])
        end

    @values[x] ||= []
    @values[x][y] = ((geological_index + depth) % 20183)
  end

  def [](location)
    value = if @values[location[0]].nil? || @values[location[0]][location[1]].nil?
              value_at(location)
            else
              @values[location[0]][location[1]]
            end

    CHART[value % 3]
  end
end

def can_enter?(cave, location, equipment)
  if location[0] < 0 || location[1] < 0
    return false
  end

  value = cave[location]
  case value
  when :rocky
    !equipment.empty? && (equipment.include?(:torch) || equipment.include?(:gear))
  when :wet
    !equipment.include?(:torch) && (equipment.include?(:gear) || equipment.empty?)
  when :narrow
    !equipment.include?(:gear) && (equipment.include?(:torch) || equipment.empty?)
  else
    raise "What is this #{value}"
  end
end

class Exploration
  attr_reader :score, :equipment, :location
  COMBINATIONS = [[], [:torch], [:gear], [:torch, :gear]]
  AROUND = [[-1, 0], [0, -1], [1, 0], [0, 1], [0, 0]]

  def initialize(score, equipment, location)
    @score = score
    @equipment = equipment
    @location = location
  end


  def next_paths
    Enumerator.new do |y|
      COMBINATIONS.each do |new_equipment|
        new_score = score + 1
        if equipment != new_equipment
          new_score = new_score + 7
        end

        AROUND.each do |loc|
          y << Exploration.new(new_score, new_equipment, [location[0] + loc[0], location[1] + loc[1]])
        end
      end

    end
  end

  def to_s
    "#{location} #{equipment}: #{score}"
  end

end

paths = PQueue.new {|a, b| a.score <= b.score}

def depth_first(cave, explorations, target, visited = Hash.new {|h, k| h[k] = Hash.new {|a, b| a[b] = Hash.new {|y, z| y[z] = false}}})
  count = 0
  while true
    exploration = explorations.pop
    if count % 1000 == 0
      puts "Looking at #{exploration}"
    end
    count += 1

    if visited[exploration.location[0]][exploration.location[1]][exploration.equipment]
      next
    end
    visited[exploration.location[0]][exploration.location[1]][exploration.equipment] = true

    if exploration.location[0] > 3 * target[0] || exploration.location[1] > 2 * target[1]
      next
    end

    if exploration.location == target && exploration.equipment.include?(:torch)
      return exploration
    end

    exploration.next_paths.each do |new_exploration|
      if can_enter?(cave, new_exploration.location, new_exploration.equipment) && can_enter?(cave, exploration.location, new_exploration.equipment)
        explorations.push(new_exploration)
      end
    end
  end
end


# Puzzle Input
depth = 7863
target = [14, 760]


#1053 to low
#1057

#1055 is to high

cave = CaveSystem.new(depth, target)
paths.push(Exploration.new(0, [:torch], [0, 0]))

shortest_path = depth_first(cave, paths, target)

puts shortest_path
