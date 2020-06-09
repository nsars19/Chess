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
  attr_accessor :tiles, :history
  
  def initialize
    @board = Board.new
    @tiles = @board.tiles
    @history = @board.history
    @player1 = @board.player1
    @player2 = @board.player2
  end
  
  def play
    put_intro
  end

  private
  def display
    keys = @tiles.keys
    numbers = (1..8).to_a.reverse
    print "\n"
    numbers.each do |number|
      print "\t#{number} "
      row = keys.filter { |key| key.include? number.to_s }
      row.each do |space|
        piece = @tiles[space]
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

  def put_intro
    display_welcome
    puts "PLAY  |  LOAD  |   INSTRUCTIONS\n".center(95)
  end

  def display_welcome
    print "\n#{' ' * 34}_:_\n#{' ' * 33}'-.-'\n #{' ' * 22}( )#{' ' * 6}__.'.__\n"
    print " #{' ' * 19}.-:---:-.#{' ' * 2}|_______|\n#{' ' * 21}\\_____/#{' ' * 4}\\=====/\n"
    print "#{' ' * 21}{=====}     )___(\n"
    print "     CCCCCCCCCCC      )___(     /_____\\     EEEEEEEEEE         SSSS          SSSS     \n"
    print "   CCCCCCCCCCCCCC    /_____\\     |   |     EEEEEEEEEEEEE     SSSSSSSS      SSSSSSSS   \n"
    print "  CCCCC               |   |      |   |     EEEE             SSS    SSS    SSS    SSS  \n"
    print " CCCCC                |   |/\\\\/\\\\|   |     EEEE             SSS           SSS         \n"
    print " CCCC                 |   |\\\\/\\\\/|   |      EEEEEEE          SSSSSSS       SSSSSSS    \n"
    print " CCCC                 |   |      |   |      EEEEEEE           SSSSSSS       SSSSSSS   \n"
    print " CCCCC               /_____\\    /_____\\    EEEE                    SSS           SSS  \n"
    print "  CCCCC             (=======)  (=======)\   EEEE             SSS    SSS    SSS    SSS  \n"
    print "   CCCCCCCCCCCCCC   }======={  }======={   EEEEEEEEEEEEE     SSSSSSSS      SSSSSSSS   \n"
    print "     CCCCCCCCCCC   (_________)(_________)   EEEEEEEEEE         SSSS          SSSS     \n\n\n"
  end
end

Game.new.play
