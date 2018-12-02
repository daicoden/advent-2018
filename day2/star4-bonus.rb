
lines = File.read("day2-input.txt").split("\n")


$cache = {}

$key = {
    'a' => 1,
    'b' => 2,
    'c' => 3,
    'd' => 4,
    'e' => 5,
    'f' => 6,
    'g' => 7,
    'h' => 8,
    'i' => 9,
    'j' => 10,
    'k' => 11,
    'l' => 12,
    'm' => 13,
    'n' => 14,
    'o' => 15,
    'p' => 16,
    'q' => 17,
    'r' => 18,
    's' => 19,
    't' => 20,
    'u' => 21,
    'v' => 22,
    'w' => 23,
    'x' => 24,
    'y' => 25,
    'z' => 26,
}

def compute_hash(id)
  index = 0
  sum = 0
  value = ""
  id.each do |char|
    sum = $key[char.downcase] + index * $key.length
    value += char
    index += 1
  end

  if $cache[sum]
    puts($cache[sum])
    exit(0)
  end
  $cache[sum] = value
end

def combinator_enumerator(string, skip_index)
  Enumerator.new(string.length - 1) do |y|
    index = 0
    string.each_char do |c|
      if index != skip_index
        y << c
      end
    end
  end

end

lines.each do |line|
  line.chars.each_with_index do |c, index|
    compute_hash(combinator_enumerator(line, index))
  end
end
exit(1)