class Board
  attr_reader :board
  
  def initialize
    @board = create_board
  end

  private
  def create_board
    board = []
    8.times do |row|
      8.times do |column|
        board << [(row + 1), (column + 1)]
      end
    end
    board
  end
end