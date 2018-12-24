#! /usr/bin/ruby
Cart = Struct.new(:x, :y, :direction, :last) do
  def move!(grid)
    case direction
    when '>'
      self.x += 1
    when '<'
      self.x -= 1
    when '^'
      self.y -= 1
    when 'v'
      self.y += 1
    end
    self.direction = corners[direction.to_sym][(grid[y][x]).to_sym] || direction
    turn!(grid) if grid[y][x] == '+'
  end

  def loc
    "#{x},#{y}"
  end

  def info
    "#{x}:#{y}, #{direction}"
  end

  private

  def turn!(grid)
    if last == 'r'
      turn_left
    elsif last == 'l'
      go_straight
    elsif last == 's'
      turn_right
    end
  end

  def turn_left
    self.direction = { '<': 'v', 'v': '>', '>': '^', '^': '<' }[direction.to_sym]
    self.last = 'l'
  end

  def turn_right
    self.direction = { '<': '^', '^': '>', '>': 'v', 'v': '<' }[direction.to_sym]
    self.last = 'r'
  end

  def go_straight
    self.last = 's'
  end

  def corners
    {
      '>': { '/': '^', '\\': 'v' },
      '<': { '/': 'v', '\\': '^' },
      '^': { '/': '>', '\\': '<' },
      'v': { '/': '<', '\\': '>' }
    }
  end
end

class Solution
  class UnknownActionError < StandardError; end
  class NoTestInputError < StandardError; end
  
  def initialize
    @input_lines = 0
    @input = []
    @grid = []
    @carts = []
    @answer = nil
    @moves = 0
    @stop_moves = 1000
  end

  def run!
    get_input # :test
    parse_input
    #display

    until collision? || @moves > @stop_moves
      move_carts
      @moves += 1
    end

    @answer = collisions.select { |k,v| v > 1 }.keys.first

    display
    puts "Answer: #{@answer}"
    puts "\033[0m"
  end

  private

  def move_carts
    @carts.sort_by { |cart| [cart.y, cart.x] }.each do |cart|
      cart.move!(@grid)
      break if collision?
    end
  end

  def collision?
    collisions.values.any? { |x| x > 1 }
  end

  def collisions
    @carts.each_with_object({}) { |cart, hsh| hsh[cart.loc] ||= 0; hsh[cart.loc] += 1 }
  end

  def max_x
    @max_x ||= @grid.first.size - 1
  end

  def max_y
    @max_y ||= @grid.size - 1
  end

  def display
    line = '     '
    @grid.first.each_with_index do |_, x|
      if x % 100 == 0
        line += (x/100).to_s
      else
        line += ' '
      end
    end
    puts line
    line = '     '
    @grid.first.each_with_index do |_, x|
      if x % 10 == 0
        line += (x/10).to_s[-1]
      else
        line += ' '
      end
    end
    puts line
    line = '     '
    @grid.first.each_with_index do |_, x|
      line += (x % 10).to_s
    end
    puts line

    @grid.each_with_index do |row, y|
      line = "#{'%3d' % y}: "
      row.each_with_index do |char, x|
        carts = @carts.select { |cart| cart.x == x && cart.y == y }
        if carts.size == 0
          line += "\033[37m#{char}\033[0m"
        elsif carts.size == 1
          line += "\033[30m\033[47m#{carts.first.direction}\033[0m"
        else
          line += "\033[37m\033[41mX\033[0m"
        end
      end
      puts line
    end
    @carts.sort_by { |cart| [cart.y, cart.x] }.each { |cart| puts cart.info }
    puts "Moves: #{@moves}"
  end

  def parse_input
    y = 0
    @input.each do |line|
      x = 0
      @grid << []
      line.split('').each do |char|
        char == ' ' ? '.' : char
        if char == '>' || char == '<'
          new_cart(x, y, char)
          char = '-'
        end
        if char == '^' || char == 'v'
          new_cart(x, y, char)
          char = '|'
        end
        @grid.last << char
        x += 1
      end
      y += 1
    end
  end

  def new_cart(x, y, dir)
    @carts << Cart.new(x, y, dir, 'r')
  end

  def get_input type = nil
    if type == :test
      file = 'test-input.txt'
    else
      file = 'input.txt'
    end
    File.open(file, 'r') do |f|
      f.each_line do |line|
        @input << line.chomp
        @input_lines += 1
      end
    end
  end
end

Solution.new.run!

