require './lib/main'

describe "Moveable" do
  let(:game) { Game.new }
  let(:board) { game.board.tiles }

  describe "#move_piece" do
    xit "changes hash values of Board objects" do
      pawn = board['a2']
      player = double("player", :pieces => [pawn], :color => :white)
      expect(game.move_piece('a2', 'a3', player, game.board.tiles)).to(
        change { game.board.tiles['a3'] }.from(nil).to(pawn)
      )
    end
  end

  describe "#get_pawn_moves" do
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

  describe "#get_rook_moves" do
    let(:player) { double("player", :color => :white, :pieces => game.board.pieces[0]) }

    it "doesn't allow movement over pieces" do
      expect(game.get_rook_moves('a1', player, board)).to eql([])
    end

    it "doesn't take friendly pieces" do
      board['a3'], board['a2'] = board['a2'], board['a3']
      expect(game.get_rook_moves('a1', player, board)).to eql(['a2'])
    end

    it "takes opponent's pieces" do
      board['a2'] = nil
      board['a4'] = board['a7']
      expect(game.get_rook_moves('a1', player, board)).to eql(['a2', 'a3', 'a4'])
    end

    it "works horizontally" do
      board['d4'], board['a1'] = board['a1'], nil
      player = double('player', :color => :white, :pieces => game.board.pieces[0])
      board['b4'] = board['a2']
      board['g4'] = board['a7']
      # enclose piece to prevent possible vertical moves from returning
      board['d3'], board['d5'] = board['d2'], board['d2']
      expect(game.get_rook_moves('d4', player, board)).to eql(['c4', 'e4', 'f4', 'g4'])
    end
    
    it "doesn't allow black pieces past other pieces" do
      pieces = game.board.pieces[1]
      player = double('player', :color => :black, :pieces => pieces)
      expect(game.get_rook_moves('a8', player, board)).to eql([])
    end
    it "allows black pieces to take opponent's pieces" do
      pieces = game.board.pieces[1]
      board['a7'] = nil
      board['a5'] = board['a2']
      player = double('player', :color => :black, :pieces => pieces)
      expect(game.get_rook_moves('a8', player, board)).to eql(['a7', 'a6', 'a5'])
    end
  end

  describe "#get_queen_moves" do
    let(:player) { double('player', :color => :black, :pieces => game.board.pieces[1]) }

    it "works diagonally" do
      board['b5'] = board['d8']
      # block off vertical & horizontal movement for brevity
      ['a5', 'c5', 'b6', 'b4'].each do |coord|
        board[coord] = board['b7']
      end
      moves = ['a6','c4', 'd3', 'e2', 'c6', 'a4']
      expect(game.get_queen_moves('b5', player, board)).to eql(moves)
    end
  end

  describe "#get_king_moves" do
    let(:player) { double('player', :color => :white, :pieces => game.board.pieces[0]) }

    it "moves one space in all directions" do
      board['d4'] = board['e1']
      moves = ['c3', 'd3', 'e3', 'c4', 'e4', 'c5', 'd5', 'e5'].sort
      expect(game.get_king_moves('d4', player, board).sort).to eql(moves)
    end

    it "doesn't take friendly pieces" do
      board['c3'] = board['e1']
      moves = ['b3', 'd3', 'b4', 'c4', 'd4']
      expect(game.get_king_moves('c3', player, board)).to eql(moves)
    end

    it "takes opponent pieces" do
      board['e2'] = board['a7']
      expect(game.get_king_moves('e1', player, board)).to eql(['e2'])  
    end

    it "doesn't allow spaces that would put king in check"
  end
end