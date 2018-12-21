MAX = 16777215
MULT = 65899
OR = 65536


START_VALUE = 8586263

test = 0
test |= OR
value = (START_VALUE * MULT) & MAX

seenValues = {}
history = []

count = 0
while value < MAX

  index = test / 256

#  puts "--"
#  puts "Value #{value} Test #{test} Index #{index}"

  if test == 1 || test == 0
    test = value | OR

    value = START_VALUE
    value += test & 255
    #puts "Value #{value}"
    value *= MULT
    value &= MAX


#    puts "A Value #{value} Test #{test} Index #{index}"

  else
    test = index
    value += (test & 255)
    value *= MULT
    value &= MAX
  end



  if count % 10000 == 0
    #puts "Value #{value} Test #{test} Index #{index}"
    #puts seenValues.count

  end

  if value == 13943296

    puts "you found it but wrong end condition"
    exit 1
  end


  count += 1
end

puts value