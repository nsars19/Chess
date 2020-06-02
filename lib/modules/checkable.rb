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

  def can_castle?(rook, player, opponent, board)
    # find King, verify it has not yet moved
    king = player.pieces.select { |piece| piece.class == King }[0]
    return false if king.moves != 0
    # verify Rook has not yet moved
    return false if rook.moves != 0
    # disallow if King is in check
    return false if puts_in_check?(king.position, opponent, board)
    # check tiles to verify no opponent piece is able to move there
    color_num = {white: 1, black: 8}
    if rook.position[0] == 'a' # Rook in 'a' column. Long castle
      ['d', 'c'].each do |letter|
        left_tiles = "#{letter}#{color_num[player.color]}"
        return false if !board[left_tiles].nil?
        return false if !board["b#{color_num[player.color]}"].nil?
        return false if puts_in_check?(left_tiles, opponent, board)
      end
    else # Rook in 'h' column. Short castle
      ['f', 'g'].each do |letter|
        right_tiles = "#{letter}#{color_num[player.color]}"
        return false if !board[right_tiles].nil?
        return false if puts_in_check?(right_tiles, opponent, board)
      end
    end
    true
  end

  def checkmate?
  end
end