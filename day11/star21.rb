$serial_number = 5177
#$serial_number =  42


def cell_power(x, y, serial_number)
  rack_id = x + 10
  power = rack_id * y + serial_number
  power = power * rack_id
  power.to_s[-3].to_i - 5
end


puts cell_power(122, 79, 57)
puts cell_power(217, 196, 39)
puts cell_power(101, 153, 71)


grid = []

(1..300).each do |x|
  (1..300).each do |y|
    grid[x] ||= []
    grid[x][y] = cell_power(x, y, $serial_number)
  end
end


def max_power(x, y, size, grid)
  cluster_power = 0
  (0...size).each do |xoff|
    (0...size).each do |yoff|
      if x + xoff > 300 || y + yoff > 300
        return nil
      end

      cluster_power += grid[x + xoff][y +yoff]
    end
  end
  cluster_power
end

$cluster_power = []

def populate_max_power(size, grid)
  if size == 1
    cluster_power = []
    (1..(300)).each do |x|
      (1..(300)).each do |y|
        cluster_power[x] ||= []
        cluster_power[x][y] = max_power(x, y, size, grid)
      end
    end
    cluster_power
  else
    cluster_power = []
    (1..(300 - size+1)).each do |x|
      (1..(300 - size+1)).each do |y|
        cluster_power[x] ||= []
        cluster_power[x][y] = $cluster_power[size - 1][x][y]
        (0...(size-1)).each do |extra|
        #  puts "Looking at #{x}, #{y} size #{size}, adding in #{x+size-1}, #{y + extra}"
        #  puts "Looking at #{x}, #{y} size #{size}, adding in #{x+extra}, #{y + size - 1}"
          cluster_power[x][y] += grid[x + size - 1][y + extra]
          cluster_power[x][y] += grid[x + extra][y + size - 1]
        end
       # puts "Bah"
       # puts "Looking at #{x}, #{y} size #{size}, adding in #{x+size - 1}, #{y + size - 1}"
        cluster_power[x][y] += grid[x + size - 1][y + size - 1]

        # puts "---"
      end
    end
    cluster_power
  end
end

max_found = [-100, 0, 0, 0]
(1..300).each do |size|
  puts "investigating #{size} #{max_found}"
  $cluster_power[size] = populate_max_power(size, grid)

  (1..(300 - size+1)).each do |x|
    (1..(300 - size+1)).each do |y|
      if ($cluster_power[size][x][y] || -100) > max_found[0]
        max_found = [$cluster_power[size][x][y], x, y, size]
      end
    end
  end

end


puts max_found.inspect
