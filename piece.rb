require_relative 'array_utility'
require 'byebug'
class Piece
  MOVE_DIRECTIONS = {
    :white => [[-1,  1], [-1, -1]],
    :black => [[ 1,  1], [ 1, -1]]
  }
  attr_reader :king, :color
  attr_accessor :pos, :board

  def initialize(king = false, board, color, pos)
    @king, @board, @color, @pos = king, board, color, pos
  end

  def to_s
    if color == :white
      king? ? "\u2654" : "\u26AA"
    else
      king? ? "\u265A" : "\u26AB"
    end
  end

  def perform_slide(new_pos)
    raise 'Invalid move' if illegal_move?(new_pos)
    board[self.pos] = nil
    self.pos = new_pos
    board[new_pos] = self
  end

  def perform_jump(new_pos) #should remove the jumped piece from the Board
    #debugger
    raise 'Invalid move' if illegal_move?(new_pos)
    board[self.pos] = nil
    opponent_piece_pos = pos.add(new_pos.diff(pos).divide(2))
    self.pos = new_pos    #update the piece to new_pos and set the jumped piece to nil
    board[new_pos] = self
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
      if maybe_conquer?(new_pos)
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
    obstructed?(new_pos) && board[new_pos].color != color && # color is not the same&& !board[new_pos].color
       !obstructed?(new_pos.add(new_pos.diff(pos)))
  end

  def king?
    self.king
  end

  def move_diffs  # returns the directions a piece could move in
    if !self.king?
      if self.color == :white
        MOVE_DIRECTIONS[:white]
      else
        MOVE_DIRECTIONS[:black]
      end
    else
      MOVE_DIRECTIONS[:white] + MOVE_DIRECTIONS[:black]
    end
  end

  def maybe_promote
    king? if
      self.pos.last == (self.color == :white ? 0 : BOARD_SIZE - 1) #and if king is not already true?
  end
end
