class Controller
  attr_reader :board, :view

  def initialize(board, view)
    @board = board
    @view = view
    @current_player = 1
    @cursor_position = 0
  end

  def run
    while true
      column = get_move
      drop_piece(column)
      if winner?(board)
        view.display_win_message(@current_player)
        break
      elsif stalemate?(board)
        view.display_tie_message
        break
      else
        get_next_player
      end
    end
  end

  def get_move
    while true
      view.display_game(board, @current_player, @cursor_position)
      input = view.get_key
      if input == :left && @cursor_position > 0
        move_cursor(-1)
      elsif input == :right && @cursor_position < (board.width - 1)
        move_cursor(1)
      elsif (input == :down || input == :enter) && board.valid_move?(@cursor_position)
        return @cursor_position
      end
    end
  end

  def drop_piece(x)
    view.animate_drop(board, @current_player, @cursor_position)
    board.play_piece(@current_player, x)
  end

  def move_cursor(delta)
    @cursor_position = @cursor_position + delta
  end

  def get_next_player
    @current_player = (@current_player == 1) ? 2 : 1
  end

  def winner?(board)
    lines = board.rows + board.columns + board.diagonals + board.antidiagonals
    lines.any? do |line|
      player_char = @current_player.to_s
      !!line.map{ |sym| sym.to_s[-1] }.join("").match(/#{player_char}{4}/)
    end
  end

  def stalemate?(board)
    board.rows.flatten.all? { |cell| cell != :empty }
  end

end