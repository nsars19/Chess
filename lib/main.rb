require_relative 'board'
require_relative 'player'
Dir["./modules/*"].each { |file| require_relative "#{file}" }
Dir["./pieces/*"].each  { |file| require "#{file}" }

class Game
  include Moveable
  include Winnable

  def initialize
    @player1 = Player.new :white
    @player2 = Player.new :black
    @board = Board.new
    add_player_pieces
  end

  private
  def add_player_pieces
    [@player1, @player2].each { |player| player.pieces = create_pieces }
  end

  def create_pieces
    pieces = [King.new, Queen.new]
    2.times { pieces << Bishop.new << Knight.new << Rook.new }
    8.times { pieces << Pawn .new }
    pieces
  end
end