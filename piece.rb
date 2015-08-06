require_relative 'array_utility'
require 'byebug'
class Piece
  MOVE_DIRECTIONS = {
    :white => [[-1,  1], [-1, -1]],
    :black => [[ 1,  1], [ 1, -1]]
  }
  attr_reader  :color
  attr_accessor :pos, :board, :king

  def initialize(king = false, board, color, pos)
    @king, @board, @color, @pos = king, board, color, pos
  end

  def perform_slide(new_pos)
    return false if illegal_move?(new_pos)
    board[self.pos] = nil
    self.pos = new_pos
    board[new_pos] = self
    true
  end

  def perform_jump(new_pos) #should remove the jumped piece from the Board
    #debugger
    return false if illegal_move?(new_pos)
    board[self.pos] = nil
    opponent_piece_pos = pos.add(new_pos.diff(pos).divide(2))
    self.pos = new_pos
    board[new_pos] = self
    board[opponent_piece_pos] = nil
    true
  end

  def perform_moves(move_sequence)
    if self.valid_move_seq?(move_sequence)
      self.perform_moves!
    else
      raise InvalidMoveError
      return false
    end
    true
  end

  def perfom_moves!(move_sequence)  #sequence is an array of pos
    move_sequence.length.times do |idx|
      if !self.perform_slide(move_sequence[idx], move_sequence[idx + 1])
      else
        if !self.perform_jump(move_sequence[idx], move_sequence[idx + 1])
          raise InvalidMoveError.new('Not valid sequence')
          return false
        end
      end
      break if idx == move_sequence - 2
    end
    true
  end

  def valid_move_seq?(move_sequence)
    dboard = board.dup
    piece = dboard[[self.pos]]
    begin
       piece.perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      puts e.message.colorize(:red)
      return false
    ensure
      board.render
    end
    true
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

  def to_s
    if color == :white
      king? ? "\u2654" : "\u26AA"
    else
      king? ? "\u265A" : "\u26AB"
    end
  end

  def illegal_move?(new_pos)
    !get_possible_moves(pos).include?(new_pos) || !board.on_board(new_pos)
  end

  def obstructed?(new_pos)
    !board[new_pos].nil?
  end

  def maybe_conquer?(new_pos)
    new_pos2 = new_pos
    if board.on_board(new_pos.add(new_pos.diff(pos)))
      new_pos2 = new_pos.add(new_pos.diff(pos))
    end
    obstructed?(new_pos) && board[new_pos].color != color &&
      !obstructed?(new_pos2)
  end

  def king?
    self.king
  end

  def maybe_promote
    if self.pos.first == (self.color == :white ? 0 : Board::BOARD_SIZE - 1) #and if king is not already true?
      if !king
        self.king = true
      end
    end
  end
end
