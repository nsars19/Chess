require 'json'

module Serializable
  def save_game filename
    Dir.mkdir('../saves/') unless Dir.exists?('../saves/')

    file = "../saves/#{filename}.json"
    File.open(file, 'w') { |file| file.puts @board.to_json }
  end
end