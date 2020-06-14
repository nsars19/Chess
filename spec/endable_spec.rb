require './lib/modules/endable'

RSpec.configure do |rspec|
  rspec.around(:example) do |ex|
    begin
      ex.run
    rescue SystemExit => e
      "SystemExit"
    end
  end
end

describe "Endable" do
  describe "#offer_draw" do
    let(:game) { Game.new }
    let(:board) { game.board }
    let(:player) { game.player1 }
    before { 50.times { board.history << ['filler', 'text', {taken: nil}] } }

    it "exits if 'y' is selected" do
      allow(STDIN).to receive(:gets).and_return("y")
      expect(STDOUT).to receive(:write).and_return(nil, nil)
      expect(game.offer_draw(player, board)).to be("SystemExit")
    end

    it "continues if 'n' is selected" do
      allow(STDIN).to receive(:gets).and_return("n")
      expect(STDOUT).to receive(:write).and_return(nil)
      expect(game.offer_draw(player, board)).not_to be("SystemExit")
    end
  end
end