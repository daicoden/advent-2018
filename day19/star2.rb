target = 10551361
#target = 961

found = false
i = 0

lcm = []
until i == target

  until found
    i += 1
    found = ((target / i).to_i * i == target)
  end
  found = false


  lcm << i
end

puts lcm.inject(0, &:+)
