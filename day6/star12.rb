

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

max_m = coordinates.map { |coord| coord[0] }.max + 1
max_n = coordinates.map { |coord| coord[1] }.max + 1

found = []

max_m.times do |m|
  max_n.times do |n|
    test_point = Point.new([m, n])
    distance = 0
    coordinates.map { |coordinate| test_point.distance_to(coordinate) }.each do |abs|
      distance += abs
    end

    if  distance < 10000
      found << [m, n, distance]
    end

  end
end

puts found.map { |x| "#{x.inspect}\n"}
puts found.size


