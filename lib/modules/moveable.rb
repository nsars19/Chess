module Moveable
  def move_piece(start, finish, player, board)
    piece = find_piece(start, board)
    reselect unless belongs_to?(piece, player.pieces)
    moves = get_moves(piece)
    if bad_move?(start, finish, piece, player) || !moves.include?(finish)
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

  def on_board? coord
    return true if BOARD_HASH.keys.include? coord
    false
  end

  def get_moves(piece)
    [Pawn, Rook, Knight, Bishop, Queen, King].each do |item|
      send("get_#{item.to_s.downcase}_moves") if piece.is_a? item
    end
  end

  def get_pawn_moves
  end

  BOARD_HASH = generate_hash
  def generate_hash
    keys = {}
    ('a'..'h').each do |letter|
      (1..8).each do |number|
        keys["#{letter}#{number}"] = nil
      end
    end
  end
end