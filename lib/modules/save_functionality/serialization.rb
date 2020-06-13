require 'json'

module Serializable
  def save_game filename
    Dir.mkdir('../saves/') unless Dir.exists?('../saves/')

    file = "./saves/#{filename}.json"
    File.open(file, 'w') { |file| file.puts @board.to_json }
  end

  def load_game filename
    file = "./saves/#{filename}.json"
    data = File.open(file, 'r') { |file| file.readline }
    self.from_json data
    self.rebuild_player
    self.rebuild_tiles
    @board.history = @history
    @board.pieces = [@player1.pieces, @player2.pieces]
  end

  def from_json string
    data = JSON.load(string).each do |var, val|
      self.instance_variable_set var, val
    end
  end

  def rebuild_player
    [@player1, @player2].each do |player|
      new_pieces = []
      old_pieces = player["@pieces"]
      old_pieces.each do |data|
        piece = get_class(data["class"]).new
        piece.position = data["@position"]
        piece.image = data["@image"]
        piece.moves = data["@moves"]
        new_pieces << piece

        case player["@color"]
        when 'white'
          @board.player1.pieces = new_pieces  
          @player1 = @board.player1
        when 'black'
          @board.player2.pieces = new_pieces
          @player2 = @board.player2
        end
      end
    end
  end

  def rebuild_tiles
    @tiles.each_key { |coord| @tiles[coord] = nil }
    [@player1.pieces, @player2.pieces].each do |pieces|
      pieces.each { |piece| @tiles[piece.position] = piece }
    end
    @board.tiles = @tiles
  end

  def get_class string
    TypeConverter.const_get(string)
  end
  
  module TypeConverter
    PAWN = Pawn
    ROOK = Rook 
    KNIGHT = Knight 
    BISHOP = Bishop 
    QUEEN = Queen 
    KING = King 
  end
end