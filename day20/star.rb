BRANCH = /(\(.*\))/

# start 200x200
complex = []

100.times do |y|
  100.times do |x|
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
        puts to_simulate.inspect
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

  [(min_x-1)..(max_x+1), (min_y-1)..(max_y+1)]
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

regex = File.read("test2-input.txt").chomp

puts regex[1...-1]

bounds = mapout(0, [50, 50], complex, regex[1...-1])

print_complex(complex, bounds[0], bounds[1])