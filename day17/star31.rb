X_REX = /x=(\d+), y=(\d+)\.\.(\d+)/
Y_REX = /y=(\d+), x=(\d+)\.\.(\d+)/

spring = [500, 0]

def parse_grid(line)
  points = []
  if line =~ X_REX
    (($2.to_i)..($3.to_i)).each do |y|
      points << [$1.to_i, y]
    end
  elsif line =~ Y_REX
    (($2.to_i)..($3.to_i)).each do |x|
      points << [x, $1.to_i]
    end
  else
    raise "Bad Line #{line}"
  end

  points
end

clay_location = File.read("test-input.txt").split("\n").flat_map {|line| parse_grid(line)}

$min_x = clay_location.map {|p| p[0]}.min
$max_x = clay_location.map {|p| p[0]}.max

$min_y = clay_location.map {|p| p[1]}.min
$max_y = clay_location.map {|p| p[1]}.max

CELLS = [:sand, :clay, :water, :fixed_water]

$scan = Hash.new {|k, v| k[v] = Hash.new {|a, b| a[b] = :sand}}
clay_location.each do |loc|
  $scan[loc[0]][loc[1]] = :clay
end


$water_level = 0
$water_count = 0

DIRECTIONS = [:down, :left, :right]

def existing_pool(point)
  if $scan[point[0]][point[1]] == :water
    return existing_pool([point[0] - 1, point[1]]) && existing_pool([point[0] + 1, point[1]])
  end

  if $scan[point[0]][point[1]] == :clay
    return true
  end

  false
end

def fill(point, is_filling = false)

  if point[1] == $max_y + 1
    return false
  end

  if $scan[point[0]][point[1]] == :clay
    return true
  end

  if $scan[point[0]][point[1]] == :fixed_water
    return true
  end

  if $scan[point[0]][point[1]] == :water
    #$scan[point[0]][point[1]] = :fixed_water
    return true
  end

  if $scan[point[0]][point[1]] == :sand
    $water_count += 1
    $scan[point[0]][point[1]] = :water

#    if existing_pool([point[0],point[1]+1])
#      return false
#    end

    is_filling = fill([point[0], point[1] + 1], false)


    if $scan[point[0]][point[1] + 1] == :clay
      left = fill([point[0] - 1, point[1]], true)
      right = fill([point[0] + 1, point[1]], true)
      return left && right
    elsif $scan[point[0]][point[1] + 1] == :water && is_filling
      left = fill([point[0] - 1, point[1]], true)
      right = fill([point[0] + 1, point[1]], true)
      return left && right
    else
      return is_filling
    end
  else
    return is_filling
  end
  raise "boom"
end

def print_ground(scan, bound_x, bound_y)
  bound_y.each do |y|
    bound_x.each do |x|
      if scan[x][y] == :clay
        print "#"
      elsif scan[x][y] == :sand
        print "."
      elsif scan[x][y] == :water
        print "~"
      elsif scan[x][y] == :fixed_water
        print "|"
      end
    end
    print "\n"
  end

end

fill(spring, false)


print_ground($scan, $min_x..$max_x, $min_y..$max_y)


puts $water_count - $min_y

