require 'spec_helper'

describe PlayersSearchController do
  let(:players) { double('players') }
  let(:service) { double('player service', find_by_substring: players) }
  before do
    allow(controller).to receive(:service).and_return(service)
  end

  describe '#index' do
    it 'returns serialized player information' do
      xhr :get, :index, search: 'b', format: :json

      expect(response).to be_success
    end
  end
end
