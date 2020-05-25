Dir["./pieces/*"].each { |file| require "#{file}" }

class Board
  attr_accessor :tiles
  attr_reader :board
  
  def initialize
    @board = create_board
    @tiles = create_cells
    @pieces = create_pieces
  end

  private
  def create_pieces
    
  end

  def create_board
    board = []
    ('a'..'h').each do |row|
      8.times do |column|
        board << [row , (column + 1)]
      end
    end
    board
  end

  def create_cells
    cells = {}
    @board.each do |coord|
      cells["#{coord.join('')}"] = nil
    end
    cells
  end
end