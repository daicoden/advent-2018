alchemical = File.read("day5-input.txt").chomp.split("")
#alchemical = "dabAcCaCBAcCcaDA".split("")


def process(chars, char_skip)
  new_chars = []
  skip = false
  last_char = ''
  index = nil
  chars.each_with_index do |char, i|
    if last_char != char && last_char.downcase == char.downcase
      index = i + 1
      skip = true
      break
    elsif char_skip == char
      index = i + 1
      skip = true
      break
    else
      new_chars << last_char unless last_char.empty?
      last_char = char
    end
  end

  new_chars << last_char unless last_char.empty? || skip

  if index.nil?
    new_chars
  else
    new_chars + chars[index..-1]
  end
end

def reduce(string, char_skip)

end
did_work = true
while did_work
  new_alchemical = process(alchemical)

  did_work = new_alchemical.size != alchemical.size
  alchemical = new_alchemical
  puts alchemical.size
end

puts alchemical.join("")
#puts alchemical.inspect
puts(alchemical.size)
