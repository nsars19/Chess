module Checkable
  # Checks current state of board and evaluates various conditions.
  # eg. is king in check? can pawn be promoted?
  def promotable?(coord, player, board)
    colors = {white: 8, black: 1}
    num = coord[1].to_i
    if board[coord].is_a?(Pawn) && num == colors[player.color]
      return true
    end
    false
  end

  def puts_in_check?(node, opponent, board)
    opponent.pieces.each do |piece|
      moves = get_moves(piece.position, opponent, board)
      return true if moves.include? node
    end
    false
  end

  def can_take_en_passant?
    # TODO: requires addition of move history to check whether a pawn moved up two
    #   on it's first move, or whether it moved up one space twice.
  end

  def can_castle?
  end

  def checkmate?
  end
end