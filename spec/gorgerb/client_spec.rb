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
            body: '{"steam_id": 1}'
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
            body: '{"steam_id":10,"kdr":{"total":3.1,"alien":2.5,"marine":3.0},"accuracy":{"total":0.4,"alien":0.6,"marine":{"total":0.4,"no_onos":0.2}}}'
          )
          Typhoeus.stub('http://gorge/players/10/statistics').and_return(res)

          stats = client.player_statistics(10)
          expect(stats.kdr.alien).to be_within(0.01).of(2.5)
        end
      end
    end
  end
end
