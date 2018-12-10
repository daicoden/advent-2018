EXP = /position=<(.*),(.*)> velocity=<(.*),(.*)>/

class Star
  attr_reader :position, :velocity

  def initialize(position, velocity)
    @position = position
    @velocity = velocity
  end

  def point_at(time)
    delta = @velocity.map { |v| v * time }
    [@position[0] + delta[0], @position[1] + delta[1]]
  end

end


stars = File.read("test-input.txt").split("\n").map do |line|
  if line =~ EXP
    Star.new([$1.to_i, $2.to_i], [$3.to_i, $4.to_i])
  else
    raise "Bad Input"
  end

end

def out(stars, time, width, height, x, y)
  puts "here we are at #{time}"
  matrix = {}
  stars.map {|star| star.point_at(time)}.each do |point|
    matrix[point[0]] ||= {}
    matrix[point[0]][point[1]] = true
  end

  (y..(y+height)).each do |n|
    (x..(x+width)).each do |m|
      matrix[m] ||= {}

      if matrix[m][n]
        print "X"
      else
        print "."
      end
    end
    print "\n"
  end
end


tick = 0
while true
  out(stars, tick, 200, 60, 100, 100)
  tick += gets.chomp.to_i
end

