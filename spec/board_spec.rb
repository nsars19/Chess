require './lib/board'

describe 'Board' do
  context 'when initialized' do
    let(:board) { Board.new }
    
    it 'creates 64 size array' do
      expect(board.board.size).to eql 64
    end
  end
end