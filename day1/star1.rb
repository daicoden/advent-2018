

puts("Hello Matt, welcome back")

lines = File.read("star1-input.txt").split("\n")

sum = 0
lines.map { |l| sum += l.to_i }
puts(sum)

