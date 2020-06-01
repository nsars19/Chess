require_relative 'board'
# require_relative 'player'
require_relative 'modules/moveable'
require_relative 'modules/winnable'
require_relative 'modules/checkable'

class Game
  include Moveable
  include Winnable
  include Checkable

  attr_reader :board, :player1, :player2
  
  def initialize
    @board = Board.new
    @player1 = @board.player1
    @player2 = @board.player2
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
end