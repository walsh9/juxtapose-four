class Board
  PLAYERS = {1 => :p1, 2 => :p2}
  
  attr_reader :width, :height

  def initialize
    @width = 7
    @height = 6
    reset
  end

  def reset
    @board = Array.new (width  * height) { :empty }
  end

  def play_piece(player, x)
    return false unless valid_move?(x)
    y = height - 1 - columns[x].reverse.index(:empty)
    set(x, y, PLAYERS.fetch(player))
    true
  end

  def valid_move?(x)
    (0...width).include?(x) && columns[x].include?(:empty)
  end

  def rows
    board.each_slice(width).reduce([]) { |rows, row| rows << row }
  end

  def columns
    rows.transpose
  end
  
  def diagonals
    diagonal_arrays = []
    ((-height + 1)...width).each do |x|
      temp_array = []
      height.times do |y|
        temp_array << board[xy_to_index(x + y, y)] if (x + y).between?(0, width - 1)
      end
      diagonal_arrays << temp_array.dup
    end
    diagonal_arrays
  end

  def antidiagonals
    rows.map! { |row| row.reverse }
    antidiagonals = diagonals
    rows.map! { |row| row.reverse }
    antidiagonals
  end

  def to_s
    rows.reduce("") do |string, row| 
      string << "|" + row.map do |cell| 
        case cell
        when :p1 then   " O "
        when :p2 then   " X "
        else            "   "
        end
      end.join("|") + "|\n"
    end
  end

  private

  def set(x, y, value)
    board[xy_to_index(x, y)] = value
  end

  def xy_to_index(x, y)
    y * width + x % width
  end

  attr_reader :board
end
