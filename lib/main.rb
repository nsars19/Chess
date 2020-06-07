require_relative 'board'
require_relative 'modules/moveable'
require_relative 'modules/endable'
require_relative 'modules/checkable'
require_relative 'modules/save_functionality/serialization'

class Game
  include Moveable
  include Endable
  include Checkable
  include Serializable

  attr_reader :board, :player1, :player2
  
  def initialize
    @board = Board.new
    @tiles = @board.tiles
    @history = @board.history
    @player1 = @board.player1
    @player2 = @board.player2
  end
  
  private
  def display
    keys = @board.tiles.keys
    numbers = (1..8).to_a.reverse
    print "\n"
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
    print "\t   a  b  c  d  e  f  g  h  \n"
    return
  end

  def display_history(amount = nil)
    board = @board.history.reverse[0..(amount.to_i - 1)]
    board.each do |move|
      print "#{move[0].to_s} #{move[1].to_s.downcase}: #{move[2]} -> #{move[3]}\n"
    end
    return nil
  end
end