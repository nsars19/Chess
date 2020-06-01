require_relative 'board'
require_relative 'player'
require_relative 'modules/moveable'
require_relative 'modules/winnable'
require_relative 'modules/checkable'

class Game
  include Moveable
  include Winnable
  include Checkable

  attr_reader :board, :player1, :player2
  
  def initialize
    @player1 = Player.new :white
    @player2 = Player.new :black
    @board = Board.new
    add_player_pieces
  end
  
  private
  def display
    keys = @board.tiles.keys
    numbers = (1..8).to_a.reverse
    print "\n\t   a  b  c  d  e  f  g  h  \n"
    numbers.each do |number|
      print "\t#{number} "
      row = keys.filter { |key| key.include? number.to_s }
      row.each do |space|
        piece = @board.tiles[space]
        if piece.nil?
          print "[ ]"
        else
          print "[#{piece.image}]"
        end
      end
      puts "\n"
    end
    print "\n"
    return
  end

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