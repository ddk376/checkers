require 'colorize'

class Board
  BOARD_SIZE = 8
  attr_reader :grid

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
  end

  def [](pos)
    row, col = pos
    @grid[row[col] = pos
  end

  def []=(pos,value)
   row, col = pos
   @grid[row][col] = value
  end

  def populate_grid
    color = :black
    BOARD_SIZE.times do |row|
      color = :white if row == BOARD_SIZE / 2
      BOARD_SIZE.times do |col|
        @grid[row][col] = Piece.new(false, self, color, [row, col]) if (col - row).even?
      end
    end
  end

  def render
    color = :default
    puts "   #{("a".."h").to_a.join("  ")}"
    BOARD_SIZE.times do |row|
      print "#{BOARD_SIZE - row} "
      BOARD_SIZE.times do |col|
        print " #{self[[row,col]].nil? ? " " : self[[row,col]].to_s} ".colorize(:background => color)
        color = switch_board_color(color)
      end
      color = switch_board_color(color)
      print "\n"
    end
    nil
  end

  def on_board(pos)
    pos.all? {|coord| coord.between?(0, BOARD_SIZE - 1) }
  end

end
