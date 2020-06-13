require_relative './player'

class CPU < Player
  def initialize pieces = nil
    @color = :black
    @pieces = pieces.nil? ? [] : pieces
  end

  def choose_piece pieces
    num = pieces.size
    chosen_piece = pieces[rand(num)]
  end
end