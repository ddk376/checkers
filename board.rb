require_relative 'piece'
require_relative 'checker_error'
require 'colorize'
require 'byebug'

class Board
  BOARD_SIZE = 8
  attr_accessor :grid

  def initialize(fill_in = true)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    populate_grid if fill_in
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos,value)
   row, col = pos
   @grid[row][col] = value
  end

  def move(start, end_pos)
    piece = self[start]
    raise CheckerError.new( "There is no piece there") if piece.nil?
    coord_difference = end_pos.diff(start)
    if piece.move_diffs.include?(coord_difference)
      piece.perform_slide(end_pos)
    else
      piece.perform_jump(end_pos) if
        piece.move_diffs.include?(coord_difference.divide(2))
    end
    self
  end

  def populate_grid
    color = :black
    BOARD_SIZE.times do |row|
      color = :white if row == BOARD_SIZE / 2 - 1
      BOARD_SIZE.times do |col|
         if row != 3 && row != 4
           if(row.even? && col.even?) || (row.odd? && col.odd?)
             self[[row, col]] = Piece.new(false, self, color, [row, col])
           end
         end
      end
    end
  end

  def render
    color = :default
    puts "   #{("a".."h").to_a.join(" ")}"
    BOARD_SIZE.times do |row|
      print "#{BOARD_SIZE - row} "
      BOARD_SIZE.times do |col|
        print "#{self[[row,col]].nil? ? " " : self[[row, col]].to_s } ".colorize(:background => color)
        color = switch_board_color(color)
      end
      color = switch_board_color(color)
      print "\n"
    end
    nil
  end

  def switch_board_color(color)
    color == :default ? :white : :default
  end

  def on_board(pos)
    pos.all? {|coord| coord.between?(0, BOARD_SIZE - 1) }
  end

  def dup
    dboard = Board.new(false)
    all_pieces.each do |piece|
      dboard[piece.pos] = Piece.new(piece.king, dboard, piece.color, piece.pos)
    end
    dboard
  end

  def all_pieces
    grid.flatten.compact
  end
end


class Array
  def add(array)
    result = []
    self.length.times do |idx|
      result << self[idx] + array[idx]
    end
    result
  end

  def diff(array)
    result = []
    self.length.times do |idx|
      result << self[idx] - array[idx]
    end
    result
  end

  def multiply(num)
    result = []
    self.length.times do |idx|
      result << self[idx] * num
    end
    result
  end

  def divide(num)
    result = []
    self.length.times do |idx|
      result << self[idx] / num
    end
    result
  end
end


if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.render
end
