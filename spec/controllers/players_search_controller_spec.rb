require 'spec_helper'

describe PlayersSearchController do
  let(:players) { double('players', as_json: {some: 'results'}) }
  let(:service) { double('player service', find_by_substring: players) }
  before do
    controller.class.using_service(service)
  end

  describe '#index' do
    it 'returns serialized player information' do
      xhr :get, :index, search: 'b'

      expect(response).to be_success
      expect(response.body).to eql('{"some":"results"}')
    end
  end
end
