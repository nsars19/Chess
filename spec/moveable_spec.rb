require './lib/main'

describe "Moveable" do
  describe "#move_piece" do
    let(:game) { Game.new }

    it "changes hash values of Board objects" do
      pawn = game.board.tiles['a2']
      player = double("player", :pieces => [pawn])
      expect(game.move_piece('a2', 'a3', player, game.board.tiles)).to(
        change { game.board.tiles['a3'] }.from(nil).to(pawn)
      )
    end
  end
end