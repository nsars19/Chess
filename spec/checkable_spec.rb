require './lib/main'

describe "Checkable" do
  let(:game) { Game.new }
  let(:board) { game.board.tiles }
  let(:player) { game.player1 }
  let(:opponent) { game.player2 }

  describe "#can_castle?" do
    let(:rook) { board['h1'] }

    it "returns false if King or Rook have moved" do
      board['e1'].moves = 2
      expect(game.can_castle?(rook, player, opponent, board)).to be false
    end

    it "returns false if King is in check" do
      game.change_board('f8', 'f2', board)
      board['f1'] = nil
      board['g1'] = nil
      expect(game.can_castle?(rook, player, opponent, board)).to be false
    end

    it "returns false with pieces between Rook and King" do
      expect(game.can_castle?(rook, player, opponent, board)).to be false
    end

    it "returns false if a piece can attack a tile that King moves through" do
      game.change_board('h8', 'f2', board) # opponent's Rook to f2
      board['f1'] = nil
      board['g1'] = nil
      expect(game.can_castle?(rook, player, opponent, board)).to be false
    end
  end
end