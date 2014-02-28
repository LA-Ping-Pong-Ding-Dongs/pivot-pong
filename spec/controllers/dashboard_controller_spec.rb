require 'spec_helper'

describe DashboardController do

  describe '#show' do

    let(:players) { ['player one data', 'player two data'] }
    let(:player_finder) { instance_double(PlayerFinder, find_all_players: players) }

    before do
      allow(controller).to receive(:new_player_finder).and_return(player_finder)
    end

    it 'responds successfully' do
      get :show

      expect(response).to be_success
      expect(assigns(:match)).to be_a_kind_of(MatchForm)
      expect(assigns(:players)).to eq(players)
    end

  end

end