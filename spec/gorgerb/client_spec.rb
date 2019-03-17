module Gorgerb
  RSpec.describe Client do
    describe '#player_statistics' do
      let(:client) { Client.new('http://gorge') }
      context 'when a timeout happens' do
        it 'throws an exception' do
          res = Typhoeus::Response.new(
            return_code: :operation_timedout
          )
          Typhoeus.stub('http://gorge/players/10/statistics').and_return(res)
        end
      end

      context 'when invalid JSON is returned' do
        it 'throws an exception' do
          res = Typhoeus::Response.new(
            code: 200,
            body: '{"foo": "bar"'
          )
          Typhoeus.stub('http://gorge/players/10/statistics').and_return(res)

          expect { client.player_statistics(10) }.to raise_error(APIError)
        end
      end

      context 'when incomplete JSON is returned' do
        it 'throws an exception' do
          res = Typhoeus::Response.new(
            code: 200,
            body: '{"n_100": {"steam_id": 1}}'
          )
          Typhoeus.stub('http://gorge/players/10/statistics').and_return(res)

          expect { client.player_statistics(10) }.to raise_error(APIError)
        end
      end

      context 'when a non-success status code is returned' do
        it 'throws an exception' do
          res = Typhoeus::Response.new(
            code: 502,
            body: 'bad gateway'
          )
          Typhoeus.stub('http://gorge/players/10/statistics').and_return(res)

          expect { client.player_statistics(10) }.to raise_error(APIError)
        end
      end

      context 'when the queried player does not exist' do
        it 'throws an exception' do
          res = Typhoeus::Response.new(
            code: 404,
            body: 'no such player'
          )
          Typhoeus.stub('http://gorge/players/10/statistics').and_return(res)

          expect { client.player_statistics(10) }.to raise_error(NoSuchPlayerError)
        end
      end

      context 'when a response is returned' do
        it 'returns a struct with the returned data' do
          res = Typhoeus::Response.new(
            code: 200,
            body: '{"_":{"steam_id":12034125},"n_30":{"kdr":{"alien":null,"marine":null},"accuracy":{"alien":null,"marine":{"total":null,"no_onos":null}},"_":{"sample_size":30}},"n_100":{"kdr":{"alien":2.08054522924411,"marine":2.73566569484937},"accuracy":{"alien":0.486577566729215,"marine":{"total":0.342548238507313,"no_onos":0.321322922525181}},"_":{"sample_size":100}}}'
          )
          Typhoeus.stub('http://gorge/players/10/statistics').and_return(res)

          stats = client.player_statistics(10)
          expect(stats.n_100.kdr.alien).to be_within(0.01).of(2.08)
        end
      end
    end
  end
end
