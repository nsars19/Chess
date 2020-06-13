module Endable
  def checkmate(player)
    player_num = {white: 1, black: 2}
    puts "Checkmate! Player #{player_num[player.color]} loses."
    exit
  end

  def stalemate
    puts "Stalemate! The game is a draw."
    exit
  end

  def offer_draw(player, board)
    if fifty_moves_rule?(board) || same_move_three_times?(player, board)
      other_player = {white: 2, black: 1} # ask other player for draw, white is p1, so ask p2.
      puts "Player #{other_player[player.color]} do you accept the draw? (y/n)"
      
      begin
        answer = STDIN.gets.chomp
        unless answer == 'y' || answer == 'n'
          raise Exception.new("Please select 'y' or 'n'") 
        end
      rescue Exception => e
        puts e
        retry
      end
      
      answer == 'y' ? draw : return
    end
  end

  def draw
    puts "\nDraw game."
    exit
  end
end