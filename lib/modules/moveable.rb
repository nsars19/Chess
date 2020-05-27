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
    [start, finish].each do |coord|
      char = coord.split('')
      return true unless ('a'..'h').include? char[0]
      return true unless (1..8).include? char[1]
    end
    false
  end

  def change_board(start, finish, board)
    board[start], board[finish] = nil, board[start]
  end

  def reselect
  end

  def get_moves(piece)
    [Pawn, Rook, Knight, Bishop, Queen, King].each do |item|
      send("get_#{item.to_s.downcase}_moves") if piece.is_a? item
    end
  end

  def get_pawn_moves
  end
end