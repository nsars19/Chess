require_relative 'board'
require_relative 'player'
require_relative 'modules/moveable'
require_relative 'modules/winnable'

class Game
  include Moveable
  include Winnable

  attr_reader :board, :player1, :player2
  
  def initialize
    @player1 = Player.new :white
    @player2 = Player.new :black
    @board = Board.new
    add_player_pieces
  end

  def puts_in_check?(node, opponent)
    opponent.pieces.each do |piece|
      moves = get_moves(piece.position, opponent, @board.tiles)
      return true if moves.include? node
    end
    false
  end
  
  private
  def add_player_pieces
    [@player1, @player2].each_with_index do |player, i|
      player.pieces = @board.pieces[i]
    end
    set_piece_images
  end

  def set_piece_images
    [@player1, @player2].each do |player|
      player.pieces.each do |piece|
        class_sym = piece.class.to_s.downcase.to_sym
        piece.image = PIECES[player.color][class_sym]
      end
    end
  end

  PIECES = {black: 
                  {
                    king: '♔',
                    queen: '♕',
                    rook: '♖',
                    bishop: '♗',
                    knight: '♘',
                    pawn: '♙',
                  },
            white:
                  {
                    king: '♚',
                    queen: '♛',
                    rook: '♜',
                    bishop: '♝',
                    knight: '♞',
                    pawn: '♟',
                  }      
  }
end