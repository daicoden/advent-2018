
lines = File.read("day2-input.txt").split("\n")


test_set = lines

lines.each do |line|
  test_set.each do |test_line|
    differences = 0
    new_string = ""
    index = 0
    line.each_char do |char|
      if char != test_line[index]
        differences += 1
      else
        new_string += char
      end
      index += 1
    end

    if  differences == 1
      puts(new_string)
      exit(0)
    end
  end

end
exit(1)
