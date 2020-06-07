require 'json'

module Serializable
  def save_game filename
    Dir.mkdir('../saves/') unless Dir.exists?('../saves/')

    file = "../saves/#{filename}.json"
    File.open(file, 'w') { |file| file.puts @board.to_json }
  end
  
  def from_json string
    string = string.gsub! 'null', 'nil'
    data = JSON.load(string).each do |var, val|
      self.instance_variable_set var, val
    end
  end
end