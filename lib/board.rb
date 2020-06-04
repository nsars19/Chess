require_relative 'player'
%w[pawn rook bishop knight king queen].each do |piece|
  require_relative "pieces/#{piece}"
end

class Board
  attr_accessor :tiles, :history
  attr_reader :board, :pieces, :player1, :player2
  
  PIECES = [Pawn, Rook, Bishop, Knight, King, Queen]

  def initialize
    @board = create_board
    @tiles = create_cells
    @history = []
    @pieces = [create_pieces, create_pieces]
    set_board
    @player1 = Player.new :white
    @player2 = Player.new :black
    add_player_pieces
  end

  private
  def set_board
    [:white, :black].each do |color|
      set_pawns(color)
      set_bishops(color)
      set_rooks(color)
      set_knights(color)
      set_kings(color)
      set_queens(color)
    end
    set_positions
  end

  [ 
    ['pawns', {white: 2, black: 7}, ('a'..'h')],
    ['rooks', {white: 1, black: 8}, ['a', 'h']],
    ['knights', {white: 1, black: 8}, ['b', 'g']],
    ['bishops', {white: 1, black: 8}, ['c', 'f']],
    ['kings', {white: 1, black: 8}, ['e']],
    ['queens', {white: 1, black: 8}, ['d']],
  ].each do |set|
      define_method("set_#{set[0]}") do |color|
        items = send("get_#{set[0]}", color)
        spots = set[1]
        chosen = spots[color]
        set[2].each { |letter| @tiles["#{letter}#{chosen}"] = items.pop }
      end
    end

  PIECES.each do |piece|
    define_method("get_#{piece.to_s.downcase}s") do |white_black|
      piece_set = {white: 0, black: 1}
      chosen = piece_set[white_black]
      pieces = @pieces[chosen].select { |item| item.is_a? piece }
    end
  end

  def create_pieces
    pieces = [King.new, Queen.new]
    2.times { pieces << Bishop.new << Knight.new << Rook.new }
    8.times { pieces << Pawn.new }
    pieces
  end

  def set_positions
    @tiles.each_key do |key|
      next if @tiles[key].nil?
      @tiles[key].position = key
    end
  end

  def create_board
    board = []
    ('a'..'h').each do |row|
      8.times do |column|
        board << [row , (column + 1)]
      end
    end
    board
  end

  def create_cells
    cells = {}
    @board.each do |coord|
      cells["#{coord.join('')}"] = nil
    end
    cells
  end

  def add_player_pieces
    [@player1, @player2].each_with_index do |player, i|
      player.pieces = @pieces[i]
    end
    set_piece_images
  end

  def set_piece_images
    [@player1, @player2].each do |player|
      player.pieces.each do |piece|
        class_sym = piece.class.to_s.downcase.to_sym
        piece.image = PIECE_IMAGES[player.color][class_sym]
      end
    end
  end

  PIECE_IMAGES = 
    {black: 
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