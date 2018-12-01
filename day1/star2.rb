puts("Hello Matt, welcome back")

lines = File.read("star1-input.txt").split("\n")

seen = {}

sum = 0
while true do
  lines.map do |l|
    sum += l.to_i
    seen[sum] ||= 0
    seen[sum] += 1
    if seen[sum] == 2
      puts(sum)
      exit(0)
    end
  end

end
