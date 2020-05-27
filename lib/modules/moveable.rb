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

  def get_moves(start, player, board)
    piece = find_piece(start, board)
    [Pawn, Rook, Knight, Bishop, Queen, King].each do |item|
      if piece.is_a? item
        send("get_#{item.to_s.downcase}_moves", start, player, board)
      end
    end
  end

  def get_pawn_moves start, player, board
    colors = {white: 1, black: -1}
    letters = %w[a b c d e f g h]
    letter_idx = letters.index(start[0])
    letter = start[0]
    number = start[1]
    moves = []
    moves << "#{letter}#{number + 2}" if start[1] == 2
    moves << "#{letter}#{number - 2}" if start[1] == 7
    moves << "#{letter}#{start[1].to_i + colors[player.color]}"
  end
end