require_relative "board"
require_relative "view"

class Controller
  attr_reader :board, :view

  def initialize
    @board = Board.new
    @view = View.new
    @player = 1
    @cursor_position = 0
  end

  def run
    while true
      view.display_game(board, @player, @cursor_position)
      input = view.get_key
      if input == :left && @cursor_position > 0
        move_cursor(-1)
      elsif input == :right && @cursor_position < (board.width - 1)
        move_cursor(1)
      elsif (input == :down || input == :enter) && board.valid_move?(@cursor_position)
        drop_piece(@cursor_position)
        get_next_player
      end
      #sleep 0.01
    end
  end

  def drop_piece(x)
    view.animate_drop(board, @player, @cursor_position)
    board.play_piece(@player, x)
  end

  def move_cursor(delta)
    @cursor_position = @cursor_position + delta
  end

  def get_next_player
    @player = (@player == 1) ? 2 : 1
  end

end

game = Controller.new
game.run