alchemical = File.read("day5-input.txt").chomp
#alchemical = "dabAcCaCBAcCcaDA".split("")


def process(chars)
  new_chars = []
  skip = false
  last_char = ''
  index = nil
  chars.each_with_index do |char, i|
    if last_char != char && last_char.downcase == char.downcase
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

def reduce(alchemical, char_skip)
  did_work = true
  puts "starting #{char_skip}"
  while did_work
    new_alchemical = process(alchemical)

    did_work = new_alchemical.size != alchemical.size
    alchemical = new_alchemical
  end

  puts "done with #{char_skip}"
  alchemical
end


threads = []
result = {}
'abcdefghijklmnopqrstuvwxyz+'.each_char do |skip|
  threads << Thread.new do
    result[skip] = reduce(alchemical.tr(skip.downcase, '').tr(skip.upcase, '').split(''), skip).size
  end
end

threads.each(&:join)

puts result
