require_relative '../board'

describe "Board" do
  let(:clean_board) {Board.new}

  describe "#initialize" do
    it "should create a board with width 7 and height 6" do
      expect(clean_board.height).to eq(6)
      expect(clean_board.width).to eq(7)
    end
  end

  describe "#play_piece" do
    it "should play a piece in a column" do
      clean_board.play_piece(1,2)
      expect(clean_board.columns[2].last).to eq(:p1)
    end

    it "should stack pieces in a column" do
      clean_board.play_piece(1,2)
      clean_board.play_piece(2,2)
      clean_board.play_piece(1,2)
      expect(clean_board.columns[2][-3..-1]).to eq([:p1,:p2,:p1])
    end
    
    it "should return true on a valid move" do
      expect(clean_board.play_piece(1,0)).to be true
    end
    
    it "should return false on an invalid move" do
      expect(clean_board.play_piece(1,-1)).to be false
      expect(clean_board.play_piece(1,clean_board.width)).to be false
      6.times { clean_board.play_piece(1,0) }
      expect(clean_board.play_piece(1,0)).to be false
    end
  end

  describe "#valid_move?" do
    it "should return true on a valid move" do
      expect(clean_board.valid_move?(0)).to be true
      expect(clean_board.valid_move?(clean_board.width - 1)).to be true
    end

    it "should return false on an invalid move" do
      expect(clean_board.valid_move?(-1)).to be false
      expect(clean_board.valid_move?(clean_board.width)).to be false
      6.times { clean_board.play_piece(1,0) }
      expect(clean_board.valid_move?(0)).to be false
    end
  end

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

  describe "line readers" do
    it "should return the correct numbers of lines" do
      expect(test_board.rows.size).to eq (test_board.height)
      expect(test_board.columns.size).to eq (test_board.width)
      expect(test_board.diagonals.size).to eq (test_board.height + test_board.width - 1)
      expect(test_board.antidiagonals.size).to eq (test_board.height + test_board.width - 1)
    end

    it "should read lines from the test board" do
      expect(test_board.rows[0]).to eq [:empty, :empty, :empty, :p2, :empty, :empty, :empty]
      expect(test_board.rows[5]).to eq [:empty, :p2, :p1, :p1, :p1, :p2, :p2]
      expect(test_board.columns[0]).to eq [:empty, :empty, :empty, :empty, :empty, :empty]
      expect(test_board.columns[6]).to eq [:empty, :empty, :p1, :p2, :p2, :p2]
      expect(test_board.diagonals[0]).to eq [:empty]
      expect(test_board.diagonals[2]).to eq [:empty, :empty, :p1]
      expect(test_board.diagonals[5]).to eq [:empty, :empty, :p2, :p1, :p1, :p2]
    end
  end
end