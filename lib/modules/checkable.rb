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

  def can_take_en_passant?(start, player, board)
    return false if start[1] != '4'
    last_move = board.history[-1]
    return false if last_move[1] != Pawn
    # index 2 & 3 are, respectively, start and finish positions of a piece's move,
    #   so if the row doesn't go from 2 -> 4 ie. a double move, then return false
    return false unless last_move[2][1] == '2' && last_move[3][1] == '4'
    letter = start[0]
    letters = ('a'..'h').to_a
    l_idx = letters.index letter
    # check for diagonality
    #   check if piece from last move is in column to the left or right of calling piece.
    #   doesn't allow leftwards checking of 'a' column, or rightwards checking of 'h' column. 
    return false unless last_move[2][0] == letters[l_idx - 1] && l_idx != 0 ||
                        last_move[2][0] == letters[l_idx + 1] && l_idx != 7
    
    true
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

  def checkmate?(player, board)
    king = player.pieces.select { |piece| piece.class == King }[0]
    opponent = player.color == :white ? @player2 : @player1
    moves = get_moves(king.position, player, board)
            .reject { |move| puts_in_check?(move, opponent, board) }

    position_in_check = puts_in_check?(king.position, opponent, board)
    return true if king.moves != 0 && moves.size == 0 && position_in_check
    false
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
end