require_relative "board"
require_relative "view"
require_relative "controller"

board = Board.new
view = View.new
game = Controller.new(board, view)
game.run