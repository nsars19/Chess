class Player
  attr_accessor :pieces
  attr_reader :color

  def initialize color
    @color = color
    @pieces = []
  end

  def to_json(*args)
    data = {}
    self.instance_variables.each do |var|
      var_data = self.instance_variable_get var
      if var == :@pieces
        data[var] = []
        var_data.each {|piece| data[var] << piece.to_json }
      else
        data[var] = var_data
      end
    end
    data.to_json
  end
end