class Piece
  attr_accessor :position, :image, :moves
  
  def initialize image = nil
    @position = nil
    @image = image
    @moves = 0
  end
end