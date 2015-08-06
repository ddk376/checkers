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

  end

  def render

  end

end
