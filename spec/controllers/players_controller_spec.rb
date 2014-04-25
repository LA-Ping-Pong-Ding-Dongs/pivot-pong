require 'spec_helper'

describe PlayersController do
  let(:service) { double('player service') }
  before do
    allow(controller).to receive(:service).and_return(service)
  end

  describe '#show' do
    context 'js request' do
      before do
        allow(service).to receive(:find).and_return(double('player'))
      end

      it 'returns serialized player information' do
        xhr :get, :show, key: 'keykeykeykey', format: :json

        expect(response).to be_success
      end
    end
  end
end
