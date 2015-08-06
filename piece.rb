class Piece
  attr_reader :king, :board, :color
  attr_accessor :pos

  def initialize(king = false, board, color, pos)
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

  def maybe_promote  #promote after each move which checks to see if a piece reached the back row

  end
end
