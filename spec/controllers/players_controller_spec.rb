require 'spec_helper'

describe PlayersController do
  let(:service) { double('player service') }
  before do
    controller.class.using_service(service)
  end

  describe '#show' do
    context 'js request' do
      before do
        allow(service).to receive(:find).and_return(double('player', as_json: {fake: 'player'}))
      end

      it 'returns serialized player information' do
        xhr :get, :show, key: 'keykeykeykey', format: :json

        expect(response).to be_success
        expect(response.body).to eq('{"results":{"fake":"player"}}')
      end
    end
  end
end
