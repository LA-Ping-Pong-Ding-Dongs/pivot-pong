require 'spec_helper'

describe DashboardController do

  describe '#show' do
    let(:match) { double('match') }
    let(:players) { double('players') }
    let(:service) { double('service', new_match: match, tournament_rankings: 'data', get_all: players) }

    before do
      allow(controller).to receive(:service).and_return(service)
      allow(players).to receive(:page).and_return(players)
      allow(players).to receive(:per).and_return(players)
    end

    it 'responds successfully' do
      get :show

      expect(response).to be_success
      expect(assigns(:match)).to eq(match)
      expect(assigns(:collection)).to eq(players)
      expect(assigns(:tournament_rankings)).to eq 'data'
    end
  end

end
