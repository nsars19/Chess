require './lib/main'

describe "Checkable" do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:player) { game.player1 }
  let(:opponent) { game.player2 }

  describe "#can_castle?" do
    let(:rook) { board.tiles['h1'] }

    it "returns false if King or Rook have moved" do
      board.tiles['e1'].moves = 2
      expect(game.can_castle?(rook, player, opponent, board)).to be false
    end

    it "returns false if King is in check" do
      game.change_board('f8', 'f2', board.tiles)
      board.tiles['f1'] = nil
      board.tiles['g1'] = nil
      expect(game.can_castle?(rook, player, opponent, board.tiles)).to be false
    end

    it "returns false with pieces between Rook and King" do
      expect(game.can_castle?(rook, player, opponent, board.tiles)).to be false
    end

    it "returns false if a piece can attack a tile that King moves through" do
      game.change_board('h8', 'f2', board.tiles) # opponent's Rook to f2
      board.tiles['f1'] = nil
      board.tiles['g1'] = nil
      expect(game.can_castle?(rook, player, opponent, board.tiles)).to be false
    end
  end

  describe "#checkmate?" do
    let(:king) { board.tiles['e1'] }

    it "returns false if not in check" do
      board.tiles['e3'] = board.tiles['e8']
      board.tiles['e3'].position = 'e3'
      board.tiles['e2'] = nil
      king.moves = 1
      expect(game.checkmate?(player, board)).to be false
    end

    it "returns true when in check with no possible moves" do
      board.tiles['e3'] = board.tiles['h8']
      board.tiles['e3'].position = 'e3'
      board.tiles['e2'] = nil
      king.moves = 1
      expect(game.checkmate?(player, board)).to be true
    end
  end

  describe "#stalemate?" do
    let(:king) { board.tiles['e1'] }

    it "returns true when not in check with no possible moves" do
      board.tiles['e3'] = board.tiles['e8']
      board.tiles['e3'].position = 'e3'
      board.tiles['e2'] = nil
      king.moves = 1
      20.times { board.history << ['filler'] }
      expect(game.stalemate?(player, board)).to be true
    end

    it "returns false when in check with no possible moves" do
      board.tiles['e3'] = board.tiles['h8']
      board.tiles['e3'].position = 'e3'
      board.tiles['e2'] = nil
      king.moves = 1
      expect(game.stalemate?(player, board)).to be false
    end
  end

  describe "#same_move_three_times?" do
    it "returns false with less than 12 total moves" do
      game.board.history = [['move info']]
      player = double("player")
      expect(game.same_move_three_times?(player, game.board)).to be false
    end

    it "returns true with three repeated moves" do
      king = King.new
      white_1 = [:white, king.class, 'e1', 'e2']
      white_2 = [:white, king.class, 'e2', 'e1']
      [0, 4, 8].each { |i| game.board.history[i] = white_1 }
      [2, 6, 10].each { |i| game.board.history[i] = white_2 }
      [1, 3, 5, 7, 9, 11].each { |i| game.board.history[i] = ['filler'] }
      player = instance_double("Player", :color => :white, :pieces => [king])
      expect(game.same_move_three_times?(player, game.board)).to be true
    end
  end
end