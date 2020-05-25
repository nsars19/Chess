Dir["./pieces/*"].each { |file| require "#{file}" }

class Board
  attr_accessor :tiles
  attr_reader :board, :pieces
  
  def initialize
    @board = create_board
    @tiles = create_cells
    @pieces = [create_pieces, create_pieces]
    set_board
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
  end

  [ 
    ['pawns', {white: 2, black: 7}, ['a'..'h']],
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

  [Pawn, Rook, Bishop, Knight, King, Queen].each do |piece|
    define_method("get_#{piece.to_s.downcase}s") do |white_black|
      piece_set = {white: 0, black: 1}
      chosen = piece_set[white_black]
      pieces = @pieces[chosen].select { |item| item.is_a? piece }
    end
  end

  def create_pieces
    pieces = [King.new, Queen.new]
    2.times { pieces << Bishop.new << Knight.new << Rook.new }
    8.times { pieces << Pawn .new }
    pieces
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
end