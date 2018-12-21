MAX = 16777215
MULT = 65899
START = 65536


START_VALUE = 8586263

test = 0
test |= START
value = START_VALUE

seenValues = {}

count = 0
while value < MAX

  index = 0
  while (index +1) * 256 <= test
    index += 1
  end

  puts "--"
  puts "Value #{value} Test #{test} Index #{index}"

  if test == 1
    value += test & 255
    value *= MULT
    value &= MAX

    test = value
    puts "A Value #{value} Test #{test} Index #{index}"
    value = START_VALUE
    value += test & 255
    #puts "Value #{value}"
    value *= MULT
    value &= MAX


  else
    puts test & 255
    value += (test & 255)
    puts "B Value #{value} Test #{test} Index #{index}"

    value *= MULT
    puts "B Value #{value} Test #{test} Index #{index}"
    value &= MAX

    test = index
    #value *= MULT
    #value &= MAX
  end

  seenValues[value] = true

  puts "Value #{value} Test #{test} Index #{index}"
  if count == 5
    exit(1)
  end

  count += 1

  if seenValues.size == 22063
    puts "FOUND IT! #{value}"
    exit(1)
  end
end

puts value