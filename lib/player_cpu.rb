require_relative './player'

class CPU < Player
  def initialize color, pieces = nil, 
    super
    @pieces = pieces.nil? ? [] : pieces
  end
end