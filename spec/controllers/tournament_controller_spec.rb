require 'spec_helper'

describe TournamentController do

  let(:tournament_double) { double(Tournament, determine_rankings: ['one', 'two']) }
  let(:presenter_double) { double(PlayerStandingJsonPresenter, as_json: 'json_data') }

  before do
    allow(controller).to receive(:tournament).and_return(tournament_double)
    allow(PlayerStandingJsonPresenter).to receive(:new).and_return(presenter_double)
  end

  describe '#show' do
    it 'returns current tournament data' do
      xhr :get, :show

      expect(tournament_double).to have_received(:determine_rankings)

      expect(response).to be_success
      expect(JSON.parse(response.body)).to eq(JSON.parse({ results: ['json_data', 'json_data'] }.to_json))
    end
  end

end
