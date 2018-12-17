lines = File.read("output.txt").split("\n")


standing_count = 0
mode = :sand

to_add = 0

REX = /#(~+)#/

lines.each do |line|
  while line.scan(REX).size > 0
    water_columns = line.scan(REX)
    water_columns.each do |column|
      if column.size > 1
        raise "AHH"
      end
      #puts column.inspect
      standing_count += column[0].size
      line = line.sub("##{column[0]}#", "##{'|' * column[0].size}#")
    end

  end

  print(line)
  print("\n")

end

puts standing_count
