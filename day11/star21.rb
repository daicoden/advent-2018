

#$serial_number = 5177

$serial_number = 18


def cell_power(x, y, serial_number)
  rack_id = x + 10
  power = rack_id * y + serial_number
  power = power * rack_id
  power.to_s[-3].to_i - 5
end


puts cell_power(122,79, 57)
puts cell_power(217,196, 39)
puts cell_power(101,153, 71)


grid = []

(1..300).each do |x|
  (1..300).each do |y|
    grid[x] ||= []
    grid[x][y] = cell_power(x, y, $serial_number)
  end
end


$cluster_power = []


def max_power(x, y, grid)
  (0...3).each do |xoff|
    (0...3).each do |yoff|
      if x + xoff > 300 || y + yoff > 300
        return nil
      end

      $cluster_power[x] ||= []
      $cluster_power[x][y] ||= 0
      $cluster_power[x][y] += grid[x + xoff][y +yoff]
    end
  end
end

(1..300).each do |x|
  (1..300).each do |y|
    max_power(x, y, grid)
  end
end

max_found = [-100, 0, 0]

(1..297).each do |x|
  (1..297).each do |y|
    if $cluster_power[x][y] > max_found[0]
      max_found = [$cluster_power[x][y], x, y]
    end
  end
end

print max_found
