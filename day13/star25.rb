class Cart
  TURNS = [:left, :straight, :right]
  DIRECTIONS = [:up, :left, :down, :right]

  attr_reader :direction, :location, :id

  def initialize(direction, location, id)
    @last_turn = -1
    @direction = direction
    @location = location
    @id = id
  end

  def move(track)
    new_location = @location
    if direction == :up
      new_location[1] -= 1
    elsif direction == :down
      new_location[1] += 1
    elsif direction == :right
      new_location[0] += 1
    elsif direction == :left
      new_location[0] -= 1
    end

    @direction = handle_direction(track, new_location)
    @location = new_location
  end

  def handle_direction(tracks, location)
    track_type = tracks[location[0]][location[1]]
    if track_type == :vertical
      unless [:up, :down].include?(direction)
        raise "Bad Location #{location} #{direction}"
      end
      direction
    elsif track_type == :horizontal
      unless [:right, :left].include?(direction)
        raise "Bad location #{location} #{direction}"
      end
      direction
    elsif track_type == :intersection
      @last_turn += 1
      turn(direction, TURNS[@last_turn % 3])
    elsif track_type == :bend
      bend(direction, location, tracks)
    else
      raise "Not Possible #{track_type}"
    end
  end

  def turn(current_direction, to_turn)
    if to_turn == :left
      DIRECTIONS[(DIRECTIONS.index(current_direction) + 1) % DIRECTIONS.length]
    elsif to_turn == :right
      DIRECTIONS[(DIRECTIONS.index(current_direction) - 1) % DIRECTIONS.length]
    elsif to_turn == :straight
      current_direction
    else
      raise "Not Possible #{to_turn}"
    end

  end

  def bend(direction, location, tracks)
    if [:left, :right].include?(direction)
      if location[1] - 1 >= 0 && tracks[location[0]][location[1] - 1] && [:vertical, :intersection].include?(tracks[location[0]][location[1] - 1])
        :up
      elsif tracks[location[0]][location[1] + 1] && [:vertical, :intersection].include?(tracks[location[0]][location[1] + 1])
        :down
      else
        raise "Bad Bend #{id} #{direction}, #{location}"
      end
    elsif [:up, :down].include?(direction)
      if location[0] - 1 >= 0 && tracks[location[0] - 1][location[1]] && [:horizontal, :intersection].include?(tracks[location[0] - 1][location[1]])
        :left
      elsif tracks[location[0] + 1][location[1]] && [:horizontal, :intersection].include?(tracks[location[0] + 1][location[1]])
        :right
      else
        raise "Bad Bend #{id} #{direction}, #{location}"
      end
    else
      raise "What is this #{direction}"
    end
  end
end

TRACK_TYPE = [:vertical, :horizontal, :bend, :intersection]

def parse_tracks(rows)
  tracks = Hash.new {|h, k| h[k] = {}}
  carts = []
  rows.each_with_index do |row, row_index|
    row.split("").each_with_index do |char, column_index|
      if "|" == char
        tracks[column_index][row_index] = :vertical
      elsif "-" == char
        tracks[column_index][row_index] = :horizontal
      elsif "+" == char
        tracks[column_index][row_index] = :intersection
      elsif ["/", "\\"].include?(char)
        tracks[column_index][row_index] = :bend
      elsif ">" == char
        tracks[column_index][row_index] = :horizontal
        carts << Cart.new(:right, [column_index, row_index], carts.length)
      elsif "<" == char
        tracks[column_index][row_index] = :horizontal
        carts << Cart.new(:left, [column_index, row_index], carts.length)
      elsif "^" == char
        tracks[column_index][row_index] = :vertical
        carts << Cart.new(:up, [column_index, row_index], carts.length)
      elsif "v" == char
        tracks[column_index][row_index] = :vertical
        carts << Cart.new(:down, [column_index, row_index], carts.length)
      elsif char == " "
        # pass
      else
        raise "Bad Parse #{char}"
      end

    end
  end

  [tracks, carts]
end

def simulate_tick(track, running_carts)

  carts = running_carts.sort do |cart_a, cart_b|
    comparison = cart_a.location[1] - cart_b.location[1]
    if comparison == 0
       comparison = cart_a.location[0] - cart_b.location[0]
    end

    comparison
  end

  cart_map = Hash.new {|h, k| h[k] = {}}
  carts.each do |cart|
    cart_map[cart.location[0]][cart.location[1]] = cart
  end

  carts.each do |cart|
    puts "Cart #{cart.id} at #{cart.location} #{cart.direction}"

    cart_map[cart.location[0]][cart.location[1]] = nil

    cart.move(track)

    if cart_map[cart.location[0]][cart.location[1]]
      puts "Crash at #{cart.location[0]}, #{cart.location[1]}"
      crashing_carts = [cart, cart_map[cart.location[0]][cart.location[1]]].map(&:id)

      running_carts.delete_if {|crash| crashing_carts.include?(crash.id)}

      cart_map[cart.location[0]][cart.location[1]] = nil
    else
      cart_map[cart.location[0]][cart.location[1]] = cart
    end
  end
  puts "---"
end

lines = File.read("day13-input.txt").split("\n")
$height = lines.length
$width = lines[0].length

track, carts = parse_tracks(lines)

def print_track
  $height.times do |y|
    $width.times do |x|

    end
  end
end

until carts.length == 1
  simulate_tick(track, carts)

  carts.each do |cart|
    #puts "Cart #{cart.id} at #{cart.location} #{cart.direction}"
  end

  #puts "---"
end

puts "Found cart #{carts[0].location}"