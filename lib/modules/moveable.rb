module Moveable
  class Utility
    def self.generate_hash
      keys = {}
      ('a'..'h').each do |letter|
        (1..8).each do |number|
          keys["#{letter}#{number}"] = nil
        end
      end
      keys
    end
  end
  BOARD_HASH = Moveable::Utility.generate_hash

  def move_piece(start, finish, player, board)
    piece = find_piece(start, board)
    reselect unless belongs_to?(piece, player.pieces)
    moves = get_moves(start, player, board)
    if bad_move?(start, finish, piece, player.pieces) || !moves.include?(finish)
      reselect()
    end
    change_board(start, finish, board)
  end

  def find_piece(node, board)
    board[node]
  end

  def belongs_to?(piece, player_pieces)
    return true if player_pieces.include? piece
    false
  end

  def bad_move?(start, finish, piece, player)
    return true unless belongs_to?(piece, player)
    [start, finish].each { |coord| return true unless on_board? coord }
    false
  end

  def change_board(start, finish, board)
    board[start], board[finish] = nil, board[start]
  end

  def reselect
    choice = gets.split
    reselect if choice.size != 2
    choice.each do |coord|
      reselect unless on_board?(coord)
    end
    choice
  end

  def on_board?(coord)
    BOARD_HASH.keys.include?(coord) ? true : false
  end

  def occupied?(coord, board)
    board[coord].nil? ? false : true
  end

  def get_moves(start, player, board)
    piece = find_piece(start, board)
    [Pawn, Rook, Knight, Bishop, Queen, King].each do |item|
      if piece.is_a? item
        send("get_#{item.to_s.downcase}_moves", start, player, board)
      end
    end
  end
  # refactor this shitshow vvv
  def get_pawn_moves(start, player, board)
    colors = {white: 1, black: -1}
    letters = %w[a b c d e f g h]
    l_idx = letters.index(start[0])
    letter = start[0]
    number = start[1].to_i
    moves = []
    # basic move -- up one (white) down one (black)
    up_one = "#{letter}#{number + colors[player.color]}"
    moves << up_one if board[up_one].nil?
    # first move -- up two (white) down two (black)
    up_two = ["#{letter}#{number + 2}", "#{letter}#{number - 2}"]
    if number == 2 && player.color == :white
      moves << up_two[0] if board[up_two[0]].nil? && board[up_one].nil?
    elsif number == 7 && player.color == :black
      moves << up_two[1] if board[up_two[1]].nil? && board[up_one].nil?
    end
    # diagonal move -- taking opponents pieces
    [1, -1].each do |num|
      diag = "#{letters[l_idx + num]}#{number + colors[player.color]}"
      if !board[diag].nil? && !belongs_to?(board[diag], player.pieces)
        unless (l_idx == 0 && num == -1) || (l_idx == 7 && num == 1)
          moves << diag
        end
      end
    end
    moves
  end

  def get_rook_moves(start, player, board)
    vertical_moves(start, player, board) + horizontal_moves(start, player, board)
  end
  
  def get_knight_moves(start, player, board)
  end

  def get_bishop_moves(start, player, board)
  end

  def get_queen_moves(start, player, board)
    vertical_moves(start, player, board) +
    horizontal_moves(start, player, board) +
    diagonal_moves(start, player, board)
  end

  def get_king_moves(start, player, board)
  end

  def vertical_moves(start, player, board)
    node = start
    moves = []
    letter = start[0]
    numbers = (1..8).to_a
    n_idx = numbers.index(start[1].to_i)
    down = numbers[0..(n_idx - 1)].reverse
    up = numbers[(n_idx + 1)..-1]
    [down, up].each do |range|
      next if start[1] == '1' && range == down
      next if start[1] == '8' && range == up
      range.each do |number|
        node = "#{letter}#{number}"
        if !board[node].nil?
          moves << node unless player.pieces.include?(board[node])
          break
        else
          moves << node
        end
      end
    end
    moves
  end

  def horizontal_moves(start, player, board)
    node = start
    moves = []
    letters = %w[a b c d e f g h]
    l_idx = letters.index(node[0])
    left = letters[0..(l_idx - 1)].reverse
    right = letters[(l_idx + 1)..-1]
    [left, right].each do |range|
      next if start[0] == 'a' && range == left
      next if start[0] == 'h' && range == right
      range.each do |letter|
        node = "#{letter}#{start[1]}"
        if !board[node].nil?
          moves << node unless player.pieces.include?(board[node])
          break
        else
          moves << node
        end
      end
    end
    moves
  end

  def diagonal_moves(start, player, board)
    node = start
    moves = []
    letters = %w[a b c d e f g h]
    l_idx = letters.index(start[0])
    left = letters[0..(l_idx - 1)].reverse
    right = letters[(l_idx + 1)..-1]
    numbers = (1..8).to_a
    n_idx = numbers.index(start[1].to_i)
    down = numbers[0..(n_idx - 1)].reverse
    up = numbers[(n_idx + 1)..-1]

    [[left, up], [right, down], [right, up], [left, down]].each do |diag|
      # joins each array eg. left & up in [left, up] into nested arrays of each individual
      # value. ie. left = [c, b, a], up = [4, 5, 6] returns [[c, 4], [b, 5], [a, 6]]
      coords = diag[0].zip(diag[1])
      coords.each do |coord|
        coord = coord.join('')
        # skip junk coordinates
        next unless BOARD_HASH.keys.include? coord
        if !board[coord].nil?
          # stop adding moves if a coordinate contains a piece. add coord if it isn't the players
          moves << coord unless player.pieces.include?(board[coord])
          break
        else
          moves << coord
        end
      end
    end
    moves  
  end
end