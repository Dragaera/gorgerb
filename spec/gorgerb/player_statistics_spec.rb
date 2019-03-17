module Gorgerb
  RSpec.describe PlayerStatistics do
    describe '::from_hsh' do
      it 'builds an object based on a hash' do
        source = {
          '_' => {
            'steam_id' => 10,
          },
          'n_30' => {
            '_' => { 'sample_size' => 30 },
            'kdr' => {
              'alien' => 5.5,
              'marine' => 3.0,
            },
            'accuracy' => {
              'alien' => 0.3,
              'marine' => {
                'total' => 0.1,
                'no_onos' => 0.05,
              },
            }
          },
          'n_100' => {
            '_' => { 'sample_size' => 100 },
            'kdr' => {
              'alien' => 4.5,
              'marine' => 2.0,
            },
            'accuracy' => {
              'alien' => 0.25,
              'marine' => {
                'total' => 0.15,
                'no_onos' => 0.1,
              },
            }
          }
        }
        stats = PlayerStatistics.from_hsh(source)

        expect(stats.steam_id).to eq 10
        expect(stats.n_30.kdr.marine).to be_within(0.01).of(3.0)
        expect(stats.n_30.accuracy.marine.total).to be_within(0.01).of(0.1)

        expect(stats.n_100.accuracy.marine.total).to be_within(0.01).of(0.15)
      end

      context 'when the hash is incomplete' do
        it 'throws an exception' do
          source = { 'n_30' => { 'steam_id' => 10 } }

          expect { PlayerStatistics.from_hsh(source) }.to raise_error(KeyError)
        end
      end
    end
  end
end
