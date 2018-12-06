
class Point
  def initialize(point)
    @point = point
    @closest = []
  end

  def m
    @point[0]
  end

  def n
    @point[1]
  end

  def [](index)
    @point[index]
  end

  def distance_to(point)
    (point.m - m).abs + (point.n - n).abs
  end

  def infinity!
    @infinity = true
  end

  def add_closest(m, n)
    @closest << Point.new([m, n])
  end

  def closest_count
    return @closest.count
  end

  def infinite?
    @infinity
  end
end

coordinates = File.read("day6-input.txt").split("\n").map { |line| Point.new(line.split(",").map { |str| str.to_i})}

# 6047
max_m = coordinates.map { |coord| coord[0] }.max + 1
max_n = coordinates.map { |coord| coord[1] }.max + 1

board = []

def min_indexes(ary)
  ary.each.with_index.find_all{ |a,i| a == ary.min }.map{ |a,b| b }
end

max_m.times do |m|
  max_n.times do |n|
    board[m] ||= []
    board[m][n] = []
    test_point = Point.new([m, n])
    board[m][n] = min_indexes(coordinates.map { |coordinate| test_point.distance_to(coordinate) })

    puts "#{m}, #{n}"

    if board[m][n].size == 1
      coordinates[board[m][n][0]].add_closest(m,n)
      if m == 0 || n == 0 || m == max_m - 1 || n == max_n - 1
        coordinates[board[m][n][0]].infinity!
      end
    end
  end
end


puts(coordinates.find_all { |coordinate| !coordinate.infinite? }.map(&:closest_count).max)
