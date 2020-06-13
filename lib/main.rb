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
  
  def start_game
    display_main_menu
    #get_menu_input
    play_game
  end

  private

  def play_game
    until game_over?
      player_number = {white: 1, black: 2}
      [@player1, @player2].each do |player|
        display_board
        num = player_number[player.color]
        puts "\nplayer #{num}'s turn."
        
        catch :end_player_turn do
          loop do
            
            opponent = player.color == :white ? @player2 : @player1
            king = player.pieces.select { |piece| piece.is_a? King }[0]
            if king_in_check?(king.position, opponent, @tiles)
              puts "Your king is in check. You must move to safety."
              king_moves = get_moves(king.position, player, @tiles)
              king_moves.reject! { |move| puts_in_check?(move, opponent, @tiles) }
              choice = prompt_and_get_input "Select your move:"

              until king_moves.include? choice[1]
                eval_user_input(choice, player, king_moves)
                break if king_moves.empty?
                choice = prompt_and_get_input "Select your move:"
              end

              start, finish = choice
              finish_position = @tiles[finish]
              if !finish_position.nil? && !player.pieces.include?(finish_position)
                opponent.remove_piece(@tiles[finish])
              end

              move_piece(start, finish, player, @board)
              throw :end_player_turn
            end

            choice = prompt_and_get_input "Select your move:"
            start, finish = choice
            piece = @tiles[start]
            moves = get_moves(start, player, @tiles)
            
            if piece.is_a? Rook
              if can_castle?(piece, player, opponent, @tiles)
                moves << 'castle'
                if choice[1] == 'castle'
                  castle(piece, player, @tiles)
                  break
                end
              end
            elsif piece.is_a? King
              rooks = player.pieces.select { |piece| piece.is_a? Rook }
              rooks.each do |rook|
                if can_castle?(rook, player, opponent, @tiles)
                  moves << "castle with rook #{rook.position}"
                  if rooks.size == 2 && choice[1] == 'castle'
                    row = {white: 1, black:8}
                    chosen_rook = @tiles[prompt_and_get_input("Please select a rook: ")[0]]
                    until can_castle?(chosen_rook, player, opponent, @tiles)
                      chosen_rook = @tiles[prompt_and_get_input("Please select a rook: ")][0]
                    end
                    castle(chosen_rook, player, @tiles)
                    throw :end_player_turn
                  elsif choice[1] == 'castle'
                    castle(rook, player, @tiles)
                    throw :end_player_turn
                  end
                end
              end
              moves.reject! { |coord| puts_in_check?(coord, opponent, @tiles) }
            end

            eval_user_input(choice, player, moves)

            if good_move?(start, finish, piece, player.pieces, moves)
              opponent.remove_piece(@tiles[finish]) if !@tiles[finish].nil?             
              move_piece(start, finish, player, @board)
              if piece.is_a?(Pawn) && promotable?(finish, player, @tiles)
                promote_pawn(finish, player, @tiles)
              end
              break
            end
          end
        end
      end
      display_board
    end
    [@player1, @player2].each do |player|
      stalemate if stalemate?(player, @board)
      checkmate(player) if checkmate?(player, @board)
    end
  end

  def eval_user_input input, player, moves
    if input[0] == 'save'
      filename = prompt_and_get_input("\nPlease select a name for this save.")[0]
      save_game filename
      exit
    elsif input[1] == 'moves' # eg. 'a2 moves' 
      puts "\nPossible moves: "
      if moves.nil? || moves.empty?
        puts("No possible moves.\n\n")
      else
        moves.each { |move| print "#{move} " }
        puts "\n\n"
      end
    elsif input[0] == 'draw'
      if same_move_three_times?(player, @board) || fifty_moves_rule?(@board)
        offer_draw(player, @board)
      else
        puts "\nCannot offer draw right now."
      end
    else
      return
    end
  end

  def display_board
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
    case prompt_and_get_input[0].downcase
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
      filename = prompt_and_get_input("\nPlease select a file, or type 'exit' to go back to the main menu: ")[0]
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

  def prompt_and_get_input string = nil
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

# Game.new.start_game