require_relative 'board'
class Game
  attr_reader :board
  attr_accessor :players

  def initialize
    @board = Board.new
    @players = {:white, :black}
  end

  def play
    until won?
      system("clear")
      board.render
      play_turn
      switch_player
    end
  end

  def won?
    board.all_pieces.all? { |el| el.color == :black } ||
      board.all_pieces.all? {|el| el.color == :white}
  end

  def switch_player
    players.rotate
  end
end
