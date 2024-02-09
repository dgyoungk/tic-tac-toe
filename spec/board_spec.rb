# For class Board test all methods that have outgoing commands

require './lib/board.rb'
require './lib/player.rb'

describe Board do
  subject(:sample_board) { described_class.new }
  describe '#update_board' do
    let(:sample_player) { instance_double(Player, name: 'Dan', marker: 'O') }
    context 'when method executes' do
      let(:position) { 7 }
      before do
        # random position value for method stubbing
        allow(sample_board.game_area).to receive(:insert).with(position, sample_player.marker)
      end

      it 'sends a message to the method #update_positions' do
        expect(sample_player).to receive(:update_positions).with(position)
        sample_board.update_board(sample_player, position)
      end
    end
  end

  describe '#set_board' do
    context 'when method is called' do
      it 'clears the board' do
        expect { sample_board.set_board }.to change { sample_board.game_area }.to all(eq ' ')
      end
    end

  end
end
