class Piece
  CARDINAL_MOVE_DIRECTIONS = [
    [-1,  1],
    [ 1,  1],
    [-1, -1],
    [ 1, -1]
  ]
  attr_reader :king, :board, :color
  attr_accessor :pos

  def initialize(king = false, board, color, pos)
    @king, @board, @color, @pos = king, board, color, pos
  end

  def perform_slide(new_pos)
    raise 'Invalid move' if illegal_move(new_pos)
    self.pos = new_pos
  end

  def perform_jump(new_pos) #should remove the jumped piece from the Board
    raise 'Invalid move' if illegal_move(new_pos)
    opponent_piece_pos = pos.add(new_pos.diff(pos))
    self.pos = new_pos    #update the piece to new_pos and set the jumped piece to nil
    board[opponent_piece_pos] = nil             #pos to new_pos we need to get the difference
  end

  def illegal_move?(new_pos)
    !get_possible_moves(pos).include?(new_pos)
  end

  def get_possible_moves(pos) # should return an array of moves that piece at pos can make
    possible_moves = []
    move_diffs.each do |card_dir|
      new_pos = pos.add(card_dir)
      possible_moves << new_pos if !obstructed?(new_pos)
      if maybe_conquer(new_pos)
        new_pos = new_pos.add(card_dir)
        possible_moves << new_pos if !obstructed?(new_pos)
      end
    end
    possible_moves
  end

  def obstructed?(new_pos)
    !board[new_pos].nil?
  end

  def maybe_conquer?(new_pos)
    !board[new_pos].nil?  && board[new_pos].color != color # color is not the same&& !board[new_pos].color
  end

  def move_diffs  # returns the directions a piece could move in
    CARDINAL_MOVE_DIRECTIONS
  end

  def maybe_promote
    self.king = true if
      self.pos.last == (self.color == :white ? 0 : BOARD_SIZE - 1) #and if king is not already true?
  end

  def to_s
    if color == :white
      king ? "\u2654" : "\u26AA"
    else
      king ? "\u265A" : "\u26AB"
    end
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
