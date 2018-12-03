require 'ostruct'


$overlap = []
$cache_to_line = {}
$overlap_count = 0

class Claim
  attr_reader :id, :rect

  def initialize(opts = {})
    @id = opts[:id]
    @rect = Rect.new(top_left: opts[:top_left], bottom_right: opts[:bottom_right])
  end

  def intersect_rect(claim)
    rect.intersect_rect(claim.rect)
  end

end

class Point
  attr_reader :x, :y

  def initialize(opts = {})
    @x = opts[:x]
    @y = opts[:y]
  end

  def to_s
    "(x: #{x}, y:#{y})"
  end
end


class Rect
  attr_reader :top_left, :bottom_right

  def initialize(opts = {})
    @top_left = opts[:top_left]
    @bottom_right = opts[:bottom_right]
  end

  # Retursn the intersection coordinates of the two rectangles
  def intersect_rect(rect)
    if intersect?(rect)
      rect = Rect.new(
          :top_left => OpenStruct.new(x: [top_left.x, rect.top_left.x].max, y: [top_left.y, rect.top_left.y].max),
          :bottom_right => OpenStruct.new(x: [bottom_right.x, rect.bottom_right.x].min, y: [bottom_right.y, rect.bottom_right.y].min)
      )


      rect.as_coordinates

    else
      return []
    end
  end

  def as_coordinates
    coords = []
    x = top_left.x
    y = top_left.y

    until x >= bottom_right.x && y >= bottom_right.y
      coords << OpenStruct.new(x: x, y: y)
      x = x + 1

      if x > bottom_right.x
        x = top_left.x
        y = y + 1
      end
    end
    coords << OpenStruct.new(x: x, y: y)

    #puts(coords)

    coords
  end

  def to_s
    "#{top_left}, #{bottom_right}"
  end


  def intersect?(rect)
    if rect.bottom_right.x < top_left.x
      return false
    end

    if rect.top_left.x > bottom_right.x
      return false
    end

    if rect.bottom_right.y < top_left.y
      return false
    end

    if rect.top_left.y > bottom_right.y
      return false
    end

    #puts("INTERSECTING #{top_left}, #{bottom_right} with #{rect.top_left}, #{rect.bottom_right}")
    return true
  end
end


#lines = File.read("day3-input.txt").split("\n")
lines = File.read("day3-input.txt").split("\n")

lines.map {|line| line.split(" ")}.each do |id, at, coord, dimension|

  m, n = coord.chomp(":").split(",").map(&:to_i)
  width, height = dimension.split("x").map(&:to_i)

  claim = Claim.new(id: id, top_left: OpenStruct.new(x: m, y: n), bottom_right: OpenStruct.new(x: m + width - 1, y: n + height -1))

  $cache_to_line[id] = claim
end


$cache_to_line.values.combination(2) do |claim1, claim2|
  claim1.intersect_rect(claim2).each do |point|
    $overlap[point.x] ||= []
    unless $overlap[point.x][point.y]
      $overlap[point.x][point.y] = true
      $overlap_count += 1
    end

  end
end

def display(map)
  max_height = map.map { |x| x.nil? ? 0 : x.length }.max

  puts("\n")
  max_height.times do |i|
    $overlap.each do |column|
      if column && column[i]
        print("X")
      else
        print(".")
      end
    end
    puts("..")
  end
end

# display($overlap)


puts($overlap_count)

