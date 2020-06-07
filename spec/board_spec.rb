require './lib/board'

describe 'Board' do
  context 'when initialized' do
    let(:board) { Board.new }
    
    it 'creates 64 size hash' do
      expect(board.tiles.size).to eql 64
    end
  end
end