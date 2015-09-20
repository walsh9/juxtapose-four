require_relative '../view.rb'
require_relative '../board.rb'

describe "View" do
  let(:test_board) do
    test_board = Board.new
    test_board.play_piece(1, 3)
    test_board.play_piece(2, 3)
    test_board.play_piece(1, 2)
    test_board.play_piece(2, 1)
    test_board.play_piece(1, 4)
    test_board.play_piece(2, 5)
    test_board.play_piece(1, 2)
    test_board.play_piece(2, 2)
    test_board.play_piece(1, 4)
    test_board.play_piece(2, 4)
    test_board.play_piece(1, 3)
    test_board.play_piece(2, 5)
    test_board.play_piece(1, 5)
    test_board.play_piece(2, 6)
    test_board.play_piece(1, 3)
    test_board.play_piece(2, 6)
    test_board.play_piece(1, 4)
    test_board.play_piece(2, 2)
    test_board.play_piece(1, 3)
    test_board.play_piece(2, 3)
    test_board.play_piece(1, 2)
    test_board.play_piece(2, 6)
    test_board.play_piece(1, 6)
    test_board.play_piece(2, 5)
    test_board.play_piece(1, 5)
    # |   |   |   | X |   |   |   |
    # |   |   | O | O |   | O |   |
    # |   |   | X | O | O | X | O |
    # |   |   | X | O | X | O | X |
    # |   |   | O | X | O | X | X |
    # |   | X | O | O | O | X | X |
    test_board
  end
  let(:view) { View.new }
  it "doesn't crash when displaying the board" do
    puts
    view.display_current_player(1)
    view.display_column_selector(1,6,test_board)
    view.display_board(test_board)
  end
end
