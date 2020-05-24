def create_piece_files
  Dir.mkdir('pieces') unless Dir.exists?('pieces')
  
  pieces = %w[Rook Knight Bishop Pawn Queen King]
  pieces.each do |piece|
    filename = "./pieces/#{piece.downcase}.rb"
    if File.exists?(filename)
      puts "#{piece}.rb already exists at #{filename}"
    else
      File.open(filename, 'w') do |file|
        file.puts "require_relative '../pieces'\n\n"
        file.puts "class #{piece} < Piece\nend"
      end
    end
  end
  return nil
end
