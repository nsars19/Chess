module Moveable
  def move_piece(start, finish, player, board)
    piece = find_piece(start, board)
    reselect unless belongs_to?(piece, player.pieces)
    moves = get_moves(piece)
    if bad_move?(start, finish) || !moves.include?(finish)
      reselect()
    end
  end

  def find_piece(node, board)
    board[node]
  end

  def belongs_to?(piece, player_pieces)
    return true if player_pieces.include? piece
    false
  end

  def bad_move?(start, finish)
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