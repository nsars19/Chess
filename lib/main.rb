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
  
  def start
    display_main_menu
    get_menu_input
  end

  private

  def play_game
    
  end

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

  def display_main_menu
    display_welcome
    puts "PLAY  |  LOAD  |  INSTRUCTIONS\n".center(90)
  end

  def get_menu_input
    case get_input[0].downcase
    when 'play'
      play_game
    when 'load'
      fetch_save_file
    when 'instructions'
      display_instructions
    else
      get_menu_input
    end
  end

  def fetch_save_file
    Dir.children('./saves/').each { |file| print "#{file[0...-5]} "; print "\n" }
    begin
      filename = get_input("\nPlease select a file, or type 'exit' to go back to the main menu: ")[0]
      # Allow backing out of 'LOAD' menu
      contains_file = Dir.children('./saves/').include?("#{filename}.json")
      raise Exception.new("File not found.") unless contains_file
      self.load_game(filename)
    rescue Exception => e 
      puts "#{e} Please select another saved game."
      retry unless filename == 'exit'
      display_main_menu
    end
  end

  def get_input string = nil
    puts string unless string.nil?
    gets.split
  end

  def good_move_input? array
   array[0..1].all? { |coord| @tiles.keys.include? coord }
  end

  def display_instructions
    puts "instructions go here."
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
