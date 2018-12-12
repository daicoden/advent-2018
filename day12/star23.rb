$zero = 0


lines = File.read("day12-input.txt").split("\n")

def parse_state(str)
  state = []
  str.each_char do |char|
    if char == "#"
      state[state.length] = true
    else
      state[state.length] = false
    end
  end
  state
end

def parse_rule(line)
  rule = {match: [], result: nil}
  result = false
  line.each_char do |char|
    if result
      if char == "#"
        rule[:result] = true
      elsif char == "."
        rule[:result] = false
      end
    else
      if char == "#"
        rule[:match][rule[:match].length] = true
      elsif char == '.'
        rule[:match][rule[:match].length] = false
      elsif char == ' '
        result = true
      end
    end

  end

  if result.nil?
    raise "InvalidInput line"
  end

  rule
end

pots = parse_state(lines[0])

rules = lines[2..-1].map do |rule|
  parse_rule(rule)
end


def left_adjust(pots)
  5.times do |_|
    pots.unshift(false)
    $zero += 1
  end
end

def right_adjust(pots)
  5.times do |_|
    pots << false
  end
end

def trim(pots)
  zero = $zero
  (0...zero).each do |index|
    if pots[index]
      break
    end

    pots.shift
    $zero -= 1
  end

  until pots[-1]
    pots.pop
  end
end

def find_rule(rules, test)
  match = rules.find_all do |rule|
    rule[:match] == test
  end

  if match.length == 0
    return {result: false}
  end

  if match.length > 1
    raise "BUG #{match.length} #{rules} #{test}"
  end

  match[0]

end



def display_pots(pots)
  str = ""
  pots.each do |char|
    if char
      str += "#"
    else
      str += "."
    end
  end

  str
end


def apply_rules(pots, rules)
  last_gen = pots.dup
  (2..(pots.length - 2)).each do |index|
    rule = find_rule(rules, last_gen[(index - 2)..(index + 2)])
    #print "Looking at #{display_pots(last_gen[(index - 2)..(index + 2)])}"
    #print "replacing #{index} #{rule[:result]}\n"

    pots[index] = rule[:result]
  end
end

cache = {}

sum = 0
prev = 0
iter = (1..50000).each do |iteration|
  local_sum = 0
  left_adjust(pots)
  right_adjust(pots)
  apply_rules(pots, rules)
  trim(pots)

  pots.each_with_index do |plant, position|
    value = position - $zero
    if plant
      local_sum += value
    end
  end

  sum += local_sum
  puts "#{local_sum - prev} #{iteration} #{local_sum}"
  if (local_sum - prev) == 73
    break iteration - 1
  end
  prev = local_sum

end

puts iter

sum = (50000000000 - iter)*73 + 10317

puts sum

