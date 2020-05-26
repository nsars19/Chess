module Moveable
  def move_piece start, finish
    piece = find_piece(start)
    moves = get_moves(piece)
    if bad_move?(start, finish) || !moves.include?(finish)
      reselect()
    end
  end

  def find_piece(node, board)
    board[node]
  end
end