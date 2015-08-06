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

  def play_turn
    begin
      print "\n"
      puts " #{current_player.to_s.capitalize}'s Turn:"
      print "\n"
      moves = get_move
    rescue InvalidMoveError => e
      system("clear")
      board.render
      print "\n"
      puts e.message.colorize(:red)
      retry
    ensure
      board.render
    end
  end

  def won?
    board.all_pieces.all? { |el| el.color == :black } ||
      board.all_pieces.all? {|el| el.color == :white}
  end

  def current_player
    players.first
  end

  def switch_player
    players.rotate!
  end
end
