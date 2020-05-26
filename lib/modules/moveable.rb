module Moveable
  def move_piece(start, finish, player, board)
    piece = find_piece(start, board)
    reselect unless piece.belongs_to? player.pieces
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
end