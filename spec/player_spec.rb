require './lib/player.rb'


describe Player do
  subject(:gamer) { described_class.new("Shiphtur") }
  describe '#initialize' do
    let(:gamer_name) { double('gamer_name', id: 'DK') }
    context 'when a new instance is created' do
      context 'when there is no other instance' do
        it "designates 'O' to the instance" do
          donger = Player.new(gamer_name.id)
          expect(donger.marker).to eq("O")
        end
      end
      context 'when there is already another instance' do
        before do
          g1 = Player.new("G1")
        end
        it "designates 'X' to the instance" do
          mino = Player.new("Mino")
          expect(mino.marker).to eq("X")
        end
      end
    end
  end

  describe '#update_positions' do
    let(:target) { double('target', value: 5) }
    context 'when method executes' do
      it "updates an instance's array of marked positions" do
        expect(gamer.marked).to receive(:push).with(target.value)
        gamer.update_positions(target.value)
      end
    end
  end
end
