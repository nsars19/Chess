module Endable
  def checkmate player
    player_num = {white: 1, black: 2}
    "Checkmate! Player #{player_num[player.color]} loses."
    exit
  end

  def stalemate
    "Stalemate! The game is a draw."
    exit
  end

  def draw
    "Draw game."
    exit
  end
end