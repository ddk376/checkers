class Piece
  CARDINAL_DIRECTIONS = [
    [-1,  1],
    [ 1,  1],
    [-1, -1],
    [ 1, -1]
  ]
  attr_reader :king, :board, :color
  attr_accessor :pos

  def initialize(king = false, board, color, pos)
    raise 'Invalid color' unless [:white, :black].include?(color)
    raise 'Invalid position' unless board.on_board?(pos)
    @king, @board, @color, @pos = king, board, color, pos
  end

  def perform_slide

  end

  def perform_jump #should remove the jumped piece from the Board

  end

  def illegal_slide?

  end

  def move_diffs  # returns the directions a piece could move in
  
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
