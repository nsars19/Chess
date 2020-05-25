Dir["./pieces/*"].each { |file| require "#{file}" }

class Board
  attr_accessor :tiles
  attr_reader :board, :pieces
  
  def initialize
    @board = create_board
    @tiles = create_cells
    @pieces = [create_pieces, create_pieces]
  end

  private
  def set_board
    set_white_pieces
    set_black_pieces
  end

  def set_pawns color
    pawns = get_pawns color
    row = {white: 2, black: 7}
    chosen = row[color]
    ('a'..'h').each { |letter| @board.tiles["#{letter}#{chosen}"] = pawns.pop }
  end

  [Pawn, Rook, Bishop, Knight].each do |piece|
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