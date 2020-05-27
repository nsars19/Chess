require_relative 'board'
require_relative 'player'
require_relative 'modules/moveable'
require_relative 'modules/winnable'

class Game
  include Moveable
  include Winnable

  attr_reader :board
  
  def initialize
    @player1 = Player.new :white
    @player2 = Player.new :black
    @board = Board.new
    add_player_pieces
  end

  private
  def add_player_pieces
    [@player1, @player2].each_with_index do |player, i|
      player.pieces = @board.pieces[i]
    end
  end
end