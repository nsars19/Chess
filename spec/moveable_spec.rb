require './lib/main'

describe "Moveable" do
  describe "#move_piece" do
    it "changes hash values of Board objects" do
      pawn = double("pawn")
      tiles = {'a2' => pawn, 'a3' => nil}
      player = double("player", :pieces => [pawn])
      game = double("game",
                    :player => player,
                    :tiles => tiles
                    )
      expect(game.move_piece('a2', 'a3', player, game.tiles)).to(
        change { game.tiles['a3'] }.from(nil).to(pawn)
      )
    end
  end
end