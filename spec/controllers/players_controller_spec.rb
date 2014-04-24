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

  describe '#edit' do
    context 'js request' do
      it 'renders a player name edit form' do
        allow(service).to receive(:find).and_return(double('player'))
        xhr :get, :edit, key: 'keykeykeykey'

        expect(response).to be_success
      end
    end
  end

  describe '#update' do
    let(:player) { double(:player) }
    context 'js response' do
      before do
        allow(controller).to receive(:url_for).and_return('/player_path')
        allow(service).to receive(:find).and_return(player)
      end
      it 'redirects to player page on success' do
        allow(player).to receive(:update_attributes).and_return(true)
        patch :update, key: 'keykeykey', player: { name: 'Mallomar' }
        expect(response).to redirect_to('http://test.host/player_path')
      end

      it 'renders edit with errors if save fails' do
        allow(player).to receive(:update_attributes).and_return(false)
        patch :update, key: 'key', player: { name: 'Templeton' }
        expect(response).to render_template('edit')
      end
    end
  end
end
