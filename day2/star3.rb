

lines = File.read("day2-input.txt").split("\n")

twos = 0
threes = 0

lines.each do |line|
  cache = {}
  line.each_char do |char|
    cache[char] ||= 0
    cache[char] += 1
  end

  two = 0
  three = 0
  cache.each do |char, count|
    if count == 2
      two = 1
    end

    if count == 3
      three = 1
    end

  end

  twos += two
  threes += three
end

puts(twos*threes)
