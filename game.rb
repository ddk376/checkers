require_relative 'board'
class Game
  ORD_DELTA = 97
  attr_reader :board
  attr_accessor :players

  def initialize
    @board = Board.new
    @players = [:black, :white]
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
      input = get_move
      move_sequence = get_move_sequence(input)
      #debugger
      board.perform_moves(move_sequence) if move_sequence.first.color == current_player
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

  def get_move
    print " Input start piece and end position (ex:'f2,f3'): "
    gets.chomp
  end

  def get_move_sequence(input)
    result = []
    input_arr = input.split(",")
    input_arr.each do |pos|
      result << convert(pos)
    end
    result
  end

  def convert(pos)
    pos_arr = pos.split("")
    col = pos_arr[0]
    row = pos_arr[1]

    row = Integer(row)
    col = String(col).downcase

    new_row = Board::BOARD_SIZE - row
    new_col = col.ord - ORD_DELTA
    [new_row, new_col]
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
