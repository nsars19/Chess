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
    return true if BOARD_HASH.keys.include? coord
    false
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
    colors = {white: 1, black: -1}
    letters = %w[a b c d e f g h]
    num = start[1].to_i
    letter = start[0]
    moves = []
    # vertical movement
    node = "#{letter}#{num + colors[player.color]}"
    until !board[node].nil?
      num += colors[player.color]
      node = "#{letter}#{num}"
      moves << node
    end
    # prevent taking friendly pieces!
    moves.pop if player.pieces.include? board[node]
    # horizontal movement
    num = start[1].to_i
    l_idx = letters.index(letter)
    [1, -1].each do |l_num|
      node = "#{letters[l_idx + l_num]}#{num}"
      until !board[node].nil? || l_idx < 0 || l_idx > 7
        l_idx += l_num
        node = "#{letters[l_idx]}#{num}"
        moves << node
      end
    end
    moves
  end

  def get_knight_moves(start, player, board)
  end

  def get_bishop_moves(start, player, board)
  end

  def get_queen_moves(start, player, board)
  end

  def get_queen_moves(start, player, board)
  end
end