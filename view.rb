require 'io/console'

class View
  PLAYERS = {1 => :p1, 2 => :p2}
  OSX_EMOJI = RUBY_PLATFORM =~ /darwin/ && File.exist?("/System/Library/Fonts/Apple Color Emoji.ttf")
  BORDERCOLOR = "\e[5;41;37m"
  SPACECOLOR = "\e[40;1;30m"
  CLEARCOLOR = "\e[0m"
  GLYPHS = {
    empty:       OSX_EMOJI ? ".." : "   ",
    p1:          OSX_EMOJI ? "🐱 " : "\e[32m O \e[0m",
    p2:          OSX_EMOJI ? "🐶 " : "\e[31m X \e[0m",
    # left:        OSX_EMOJI ? "◀️  "  : " > ",
    # right:       OSX_EMOJI ? "▶️ "  : " > ",
    # down:        OSX_EMOJI ? "⏬ " : " v ",
    spacer:        OSX_EMOJI ? "  " : "   ",
    column_spacer: OSX_EMOJI ? "" : " ",
    border_spacer: "  ",
    left_edge:            OSX_EMOJI ? "#{BORDERCOLOR}🐾 #{CLEARCOLOR}"  : "#{BORDERCOLOR}║#{CLEARCOLOR}",
    right_edge:           OSX_EMOJI ? "#{BORDERCOLOR}🐾 #{CLEARCOLOR}"  : "#{BORDERCOLOR}║#{CLEARCOLOR}",
    column_separator:     OSX_EMOJI ? ""                              : "#{BORDERCOLOR}║#{CLEARCOLOR}",
    bottom_row_corner_l:  OSX_EMOJI ? "#{BORDERCOLOR}🐾 #{CLEARCOLOR}"  : "#{BORDERCOLOR}╚#{CLEARCOLOR}",
    bottom_row_corner_r:  OSX_EMOJI ? "#{BORDERCOLOR}🐾 #{CLEARCOLOR}"  : "#{BORDERCOLOR}╝#{CLEARCOLOR}",
    bottom_row_col:       OSX_EMOJI ? "#{BORDERCOLOR}🐾 #{CLEARCOLOR}" : "#{BORDERCOLOR}═══#{CLEARCOLOR}",
    bottom_row_separator: OSX_EMOJI ? ""                              : "#{BORDERCOLOR}╩#{CLEARCOLOR}"
  }

  # Thanks https://gist.github.com/acook/4190379
  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def get_key
    char = read_char

    case char
    when " "
      :space
    when "\r"
      :enter
    when "\e[B"
      :down
    when "\e[C"
      :right
    when "\e[D"
      :left
    when "\u0003"
      # control-c
      exit 0
    when /^.$/
      char
    else
      nil
    end
  end

  def clear_display
    print "\e[H\e[2J"
  end

  def display_current_player(number)
    print "Player #{number}'s turn."
    puts
  end

  def display_column_selector(player, col, board)
    print GLYPHS[:border_spacer] + (GLYPHS[:column_spacer] + GLYPHS[:spacer]) * (col)
    # print GLYPHS[:left] if col > 0
    print GLYPHS[PLAYERS[player]]
    # print GLYPHS[:right] if col < board.width - 1
    # puts
    # print GLYPHS[:border_spacer] + (GLYPHS[:column_spacer] + GLYPHS[:spacer]) * (col)
    # print GLYPHS[:down] if board.valid_move?(col)
    puts
    puts
  end

  def display_board(board)
    board.rows.each do |row|
      print GLYPHS[:left_edge]
      print row.map { |cell| "#{SPACECOLOR}#{GLYPHS[cell]}#{CLEARCOLOR}" }.join(GLYPHS[:column_separator])
      puts GLYPHS[:right_edge]
    end
    print GLYPHS[:bottom_row_corner_l]
    print (Array.new (board.width) {GLYPHS[:bottom_row_col]}).join(GLYPHS[:bottom_row_separator])
    puts GLYPHS[:bottom_row_corner_r]
  end

  def display_game(board, player, cursor_position, hide_ui = false)
    clear_display
    unless hide_ui
      display_current_player(player)
      display_column_selector(player, cursor_position, board)
    else
      print "\n\n\n"
    end
    display_board(board)
  end

  def animate_drop(board, player, x, delay = 0.1)
    (board.columns[x].count { |cell| cell == :empty }).times do |y|
      temp_board = board.dup
      temp_board.set(x, y, PLAYERS[player])
      display_game(temp_board, player, x, true)
      sleep delay
    end
  end

end