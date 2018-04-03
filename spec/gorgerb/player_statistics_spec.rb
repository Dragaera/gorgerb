module Gorgerb
  RSpec.describe PlayerStatistics do
    describe '::from_hsh' do
      it 'builds an object based on a hash' do
        source = {
          'steam_id' => 10,
          'kdr' => {
            'total' => 4.5,
            'alien' => 5.5,
            'marine' => 3.0,
          },
          'accuracy' => {
            'total' => 0.2,
            'alien' => 0.3,
            'marine' => {
              'total' => 0.1,
              'no_onos' => 0.05,
            },
          }
        }
        stats = PlayerStatistics.from_hsh(source)

        expect(stats.steam_id).to eq 10
        expect(stats.kdr.marine).to be_within(0.01).of(3.0)
        expect(stats.accuracy.marine.total).to be_within(0.01).of(0.1)
      end

      context 'when the hash is incomplete' do
        it 'throws an exception' do
          source = { 'steam_id' => 10 }

          expect { PlayerStatistics.from_hsh(source) }.to raise_error(KeyError)
        end
      end
    end
  end
end
