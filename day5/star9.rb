alchemical = File.read("day5-input.txt").chomp
#alchemical = "dabAcCaCBAcCcaDA".split("")


def process(chars)
  new_chars = []
  skip = false
  last_char = ''
  index = 0
  while index < chars.size
    char = chars[index]
    if last_char != char && last_char.downcase == char.downcase
      new_chars.pop
      last_char = new_chars[-1] || ''
      skip = true
    else
      new_chars << char
      last_char = char
    end
    index = index + 1
  end

  new_chars << last_char unless last_char.empty? || skip

   new_chars
end

def reduce(alchemical, char_skip)
=begin
  did_work = true
  puts "starting #{char_skip}"
  while did_work
    new_alchemical = process(alchemical)

    did_work = new_alchemical.size != alchemical.size
    alchemical = new_alchemical
    puts alchemical.size
  end

  puts "done with #{char_skip}"
  alchemical
=end
  process(alchemical)
end


threads = []
result = {}
'+abcdefghijklmnopqrstuvwxyz'.each_char do |skip|
  threads << Thread.new do
    r = reduce(alchemical.tr(skip.downcase, '').tr(skip.upcase, '').split(''), skip)
    result[skip] = r.size
  end
end

threads.each(&:join)

puts result
