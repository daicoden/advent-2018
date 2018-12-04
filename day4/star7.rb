require 'date'
$guard_sleep = Hash.new {|h| 0}
$guard_histogram = Hash.new {|h, k| h[k] = Hash.new { |h| 0 }}


lines = File.read("day4-input.txt").split("\n")

events = []
lines.each do |line|
  if line =~ /\[(.*)\] (.*)/
    event_time = DateTime.strptime($1, "%Y-%m-%d %H:%M")

    event = $2

    id = nil
    event_type = nil

    if event.start_with?("Guard")
      event_type = :start
      /#(\d+)/.match(event)
      id = $1
    elsif event.start_with?("falls")
      event_type = :sleep
    elsif event.start_with?("wakes")
      event_type = :wake
    else
      raise "Unknown event #{line}"
    end

    events << [event_time, event_type, id]

  else
    raise "Noooo"
  end
end

events.sort!


last_id = nil
last_sleep = nil

puts events.size
events.each do |event_time, event_type, id|
  case event_type
  when :start
    last_id = id
    last_sleep = nil
  when :sleep
    raise "Guard #{last_id} should be awake" if last_sleep
    raise "No guard to sleep" unless last_id
    last_sleep = event_time.minute
  when :wake
    raise "Guard should be asleep #{last_id}" unless last_sleep
    raise "no guard" unless last_id
    $guard_sleep[last_id] += event_time.minute - last_sleep

    (last_sleep...event_time.minute).each do |sleeping|
      $guard_histogram[last_id][sleeping] += 1
    end
    last_sleep = nil
  end

end

def max_by_key(hash)
  max_id = nil
  max = 0
  hash.each do |id, time|
    if time > max
      max_id = id
      max = time
    end
  end

  [max_id, max]
end
=begin
max_guard_id = max_by_key($guard_sleep)
puts max_guard_id


max_minute = max_by_key($guard_histogram[max_guard_id])

puts max_minute

puts "sum = #{max_minute.to_i * max_guard_id.to_i}"
=end

$guard_histogram.each do |guard, times|
  minute, count = max_by_key(times)
  puts "#{guard} #{minute}, #{count}"

end
