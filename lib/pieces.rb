class Piece
  attr_accessor :position, :image, :moves
  
  def initialize image = nil
    @position = nil
    @image = image
    @moves = 0
  end

  def to_json(*args)
    data = {}
    self.instance_variables.each do |var|
      data[:class] = self.class
      data[var] = self.instance_variable_get var
    end
    data
  end
end