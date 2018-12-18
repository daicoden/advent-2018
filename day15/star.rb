
class Unit
  attr_reader :hitpoints, :attack

  def initialize(type)
    @hitpoints = 200
    @attack = 3
    @type = type
  end
end

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

end

def around(point)
  Enumerator.new(4) do |rator|

    rator << Point.new(point.x, point.y - 1)
    rator << Point.new(point.x-1, point.y)
    rator << Point.new(point.x+1, point.y)
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

def at_path(map, location, goal)
end

def breadth_search(start, goal, paths = [])
  goal_reached = false
  paths << [[start]]
  visited = []

  until goal_reached
    new_paths = []
    until paths.empty?
      current_path = paths.shift
      around(current_path.last).each do |neighbor|
        if visited?(visited, neighbor)
          next
        end

        path = at_path(map, neighbor, goal)
        if blocked?(map, neighbor)
          next
        end


        if target_found?(map, neighbor, goal)
          return current_path + [neighbor]
        end


        visited[neighbor.x][neighbor.y] = true
        new_paths << current_path + [neighbor]
      end
    end

    paths = new_paths
  end
end