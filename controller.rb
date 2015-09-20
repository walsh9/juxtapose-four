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
      view.clear_display
      view.display_current_player(@player)
      view.display_column_selector(@player, @cursor_position, board)
      view.display_board(board)

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
    (board.columns[x].count { |cell| cell == :empty }).times do |y|
      view.clear_display
      view.display_current_player(@player)
      view.display_column_selector(nil, @cursor_position, board)
      view.display_board_with_extra_piece(board, @player, x, y)
      sleep 0.2
    end
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