require './lib/main'

describe "Moveable" do
  describe "#move_piece" do
    let(:game) { Game.new }

    xit "changes hash values of Board objects" do
      pawn = game.board.tiles['a2']
      player = double("player", :pieces => [pawn], :color => :white)
      expect(game.move_piece('a2', 'a3', player, game.board.tiles)).to(
        change { game.board.tiles['a3'] }.from(nil).to(pawn)
      )
    end
  end

  describe "#get_pawn_moves" do
    let(:game) { Game.new }
    let(:board) { game.board.tiles }

    it "allows taking opponents pieces" do
      # doesn't allow traveling across board eg. a2 -> h3
      %w[b h].each do |letter|  
        board["#{letter}3"] = double('pawn')
      end
      pawn = board['a2']
      player = double("player", :color => :white, :pieces => [pawn])
      expect(game.get_pawn_moves('a2', player, board)).to eql(['a3', 'a4', 'b3'])
    end

    it "doesn't allow taking friendly pieces" do
      board['b3'] = board['h2']
      pawns = [board['a2'], board['b3']]
      player = double("player", :color => :white, :pieces => pawns)
      expect(game.get_pawn_moves('a2', player, board)).to eql(['a3', 'a4'])
    end

    it "doesn't allow movement over pieces" do
      board['a3'] = board['b2']
      pawns = [board['a2'], board['a3']]
      player = double("player", :color => :white, :pieces => pawns)
      expect(game.get_pawn_moves('a1', player, board)).to eql([])
    end
    
    it "doesn't allow black pieces past other pieces" do
      board['a6'] = board['b7']
      pawns = [board['a6'], board['a7']]
      player = double("player", :color => :black, :pieces => pawns)
      expect(game.get_pawn_moves('a7', player, board)).to eql([])
    end

    it "allows black pieces to take opponent's pieces" do
      board['b6'] = board['b2']
      pawn = board['a7']
      player = double("player", :color => :black, :pieces => [pawn])
      expect(game.get_pawn_moves('a7', player, board)).to eql(['a6', 'a5', 'b6'])
    end

    it "doesn't allow black pieces to take friendly pieces" do
      board['b6'] = board['b7']
      pawns = [board['a7'], board['b6']]
      player = double("player", :color => :black, :pieces => pawns)
      expect(game.get_pawn_moves('a7', player, board)).to eql(['a6', 'a5'])
    end
  end
end