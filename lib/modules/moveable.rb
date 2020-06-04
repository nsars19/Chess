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
  LETTERS = ('a'..'h').to_a
  NUMBERS = (1..8).to_a

  def move_piece(start, finish, player, board)
    piece = board[start]
    reselect unless belongs_to?(piece, player.pieces)
    moves = get_moves(start, player, board)
    if bad_move?(start, finish, piece, player.pieces) || !moves.include?(finish)
      reselect()
    end
    add_move_to_history(start, finish, player, board)
    change_board(start, finish, board)
  end

  def add_move_to_history(start, finish, player, board)
    piece = board.tiles[start]
    board.history << [player.color, piece.class.to_s, start, finish, piece]
  end

  def change_board(start, finish, board)
    change_piece_position(start, finish, board)
    board[finish] = board[start]
    board[start] = nil
  end

  def change_piece_position(start, finish, board)
    board[start].position = finish
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

  def promote_pawn(coord, player, board)
    queen_char = {white: '♛', black: '♕'}
    board[coord] = Queen.new(queen_char[player.color])
    board[coord].position = coord
    player.pieces << board[coord]
  end

  def castle(rook, player, board)
    piece_row = {white: 1, black: 8}
    king = board["e#{piece_row[player.color]}"]
    column = rook.position[0]
    column == 'a' ? long_castle(rook, king, board) : short_castle(rook, king, board)
  end
  
  def long_castle(rook, king, board)
    change_board(rook.position, "d#{rook.position[1]}", board)
    change_board(king.position, "c#{king.position[1]}", board)
    [rook, king].each { |piece| piece.moves += 1 }
  end

  def short_castle(rook, king, board)
    change_board(rook.position, "f#{rook.position[1]}", board)
    change_board(king.position, "g#{king.position[1]}", board)
    [rook, king].each { |piece| piece.moves += 1 }
  end

  def get_moves(start, player, board)
    return nil if board[start].nil?
    # send piece at coordinate to it's respective move-fetching method
    piece_class = board[start].class.to_s.downcase
    return send("get_#{piece_class}_moves", start, player, board)
  end
 
  def get_pawn_moves(start, player, board)
    l_idx = LETTERS.index(start[0])
    letter = start[0]
    number = start[1].to_i
    move_options = {white: 2, black: 7}
    if number == move_options[player.color]
      moves = vertical_moves(start, player, board, 2)
    else
      moves = vertical_moves(start, player, board, 1)
    end
    moves = moves.select { |coord| coord[1].to_i > number } if player.color == :white
    moves = moves.select { |coord| coord[1].to_i < number } if player.color == :black
    # get possible diagonal moves
    colors = {white: 1, black: -1}
    [1, -1].each do |num|
      # get letters to the 'left' and 'right' of current letter.
      # direction of vertical movement based on player color 'number + 1' or 'number -1'
      diag = "#{LETTERS[l_idx + num]}#{number + colors[player.color]}"
      if !board[diag].nil? && !belongs_to?(board[diag], player.pieces)
        # prevent travel from row 8 to row 1 via Einstein-Rosen bridges
        unless (l_idx == 0 && num == -1) || (l_idx == 7 && num == 1)
          moves << diag
        end
      end
    end
    # prevents 2-space forward movement if a piece is directly in-front-of the pawn
    moves.reject do |move|
      one_ahead = "#{letter}#{number + colors[player.color]}"
      !board[one_ahead].nil? && move == one_ahead
    end
  end

  def get_rook_moves(start, player, board)
    vertical_moves(start, player, board) +
    horizontal_moves(start, player, board)
  end
  
  def get_knight_moves(start, player, board)
    # amount of change in coordinates
    moves = [2, 1, -1, -2].permutation(2)
                          .to_a
                          .filter { |move| (move[0] * move[1]).abs == 2 }

    l_idx = LETTERS.index(start[0])
    n_idx = NUMBERS.index(start[1].to_i)
    possible_moves = []
    moves.each do |set|
      next if l_idx + set[0] < 0 || n_idx + set[1] < 0
      next if l_idx + set[0] > 7 || n_idx + set[1] > 7
      node = "#{LETTERS[l_idx + set[0]]}#{NUMBERS[n_idx + set[1]]}"
      possible_moves << node unless player.pieces.include?(board[node])
    end
    possible_moves
  end

  def get_bishop_moves(start, player, board)
    diagonal_moves(start, player, board)
  end

  def get_queen_moves(start, player, board)
    vertical_moves(start, player, board) +
    horizontal_moves(start, player, board) +
    diagonal_moves(start, player, board)
  end

  def get_king_moves(start, player, board)
    moves = []
    l_idx = LETTERS.index(start[0])
    prev_l = LETTERS[l_idx - 1]
    next_l = LETTERS[l_idx + 1]
    n_idx = NUMBERS.index(start[1].to_i)
    prev_n = NUMBERS[n_idx - 1]
    next_n = NUMBERS[n_idx + 1]

    [prev_n, NUMBERS[n_idx], next_n].each do |number|
      # prevent teleporting from row 1 to row 8 and vice versa
      next if start[1] == '1' && number == prev_n
      next if start[1] == '8' && number == next_n
      [prev_l, LETTERS[l_idx], next_l].each do |letter|
        # prevent teleporting from column a to column h and vice versa
        next if start[0] == 'a' && letter == prev_l
        next if start[0] == 'h' && letter == next_l
        node = "#{letter}#{number}"
        unless node == start
          moves << node if !player.pieces.include?(board[node])
        end
      end
    end
    moves
  end
  # logic describing vertical, horizontal, and diagonal movement. used by above methods
  #   with respect to each pieces pattern of movement
  def vertical_moves(start, player, board, amount = nil)
    moves = []
    letter = start[0]
    n_idx = NUMBERS.index(start[1].to_i)
    down = NUMBERS[0..(n_idx - 1)].reverse
    up = NUMBERS[(n_idx + 1)..-1]
    # select amount of squares up to check with `amount` parameter.
    # no argument supplied evaluates to [0..-1], or the whole array.
    # `up` and `down` are ordered by their distance from the starting node, from closest
    #   to farthest.
    down_amount = down[0..(amount.to_i - 1)]
    up_amount = up[0..(amount.to_i - 1)]
    # iterate over selected amount of vertical tiles, both above and below start point
    [down_amount, up_amount].each do |range|
      # prevent movement from bottom row to top row via 'teleporting'
      next if start[1] == '1' && range == down_amount
      # prevent movement from top to bottom via 'teleporting'
      next if start[1] == '8' && range == up_amount
      # iterate over vertical tiles
      range.each do |number|
        node = "#{letter}#{number}"
        # stops when a tile containing another piece is found. if the piece belongs to
        #   the player who called the method, that tile is not added.
        if !board[node].nil?
          moves << node unless player.pieces.include?(board[node])
          break
        else
          # otherwise the tile is added to the possible moves.
          moves << node
        end
      end
    end
    moves
  end

  def horizontal_moves(start, player, board, amount=nil)
    node = start
    moves = []
    l_idx = LETTERS.index(node[0])
    left = LETTERS[0..(l_idx - 1)].reverse
    left_amount = left[0..(amount.to_i - 1)]
    right = LETTERS[(l_idx + 1)..-1]
    right_amount = right[0..(amount.to_i - 1)]

    [left_amount, right_amount].each do |range|
      next if start[0] == 'a' && range == left_amount
      next if start[0] == 'h' && range == right_amount
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

  def diagonal_moves(start, player, board, amount = nil)
    node = start
    moves = []
    l_idx = LETTERS.index(start[0])
    left = LETTERS[0..(l_idx - 1)].reverse[0..(amount.to_i - 1)]
    right = LETTERS[(l_idx + 1)..-1][0..(amount.to_i - 1)]
    n_idx = NUMBERS.index(start[1].to_i)
    down = NUMBERS[0..(n_idx - 1)].reverse[0..(amount.to_i - 1)]
    up = NUMBERS[(n_idx + 1)..-1][0..(amount.to_i - 1)]

    [[left, up], [right, down], [right, up], [left, down]].each do |diag|
      # joins each array eg. left & up in [left, up] into nested arrays of each individual
      #   value. ie. left = [c, b, a], up = [4, 5, 6] returns [[c, 4], [b, 5], [a, 6]]
      coords = diag[0].zip(diag[1])
      coords.each do |coord|
        coord = coord.join('')
        # skip junk coordinates & prevent teleporting across board
        next unless BOARD_HASH.keys.include? coord
        next if start[0] == 'a' && diag[0] == left
        next if start[0] == 'h' && diag[0] == right
        next if start[1] == '8' && diag[1] == up
        next if start[1] == '1' && diag[1] == down 
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