require 'spec_helper'

describe TournamentController do

  let(:tournament_ranking_double) { double(TournamentRanking, determine_rankings: ['one', 'two']) }
  let(:presenter_double) { double(PlayerStandingJsonPresenter, as_json: 'json_data') }

  before do
    allow(controller).to receive(:tournament_ranking).and_return(tournament_ranking_double)
    allow(PlayerStandingJsonPresenter).to receive(:new).and_return(presenter_double)
  end

  describe '#show' do
    context 'responds with json' do
      it 'returns current tournament data' do
        xhr :get, :show

        expect(tournament_ranking_double).to have_received(:determine_rankings)

        expect(response).to be_success
        expect(JSON.parse(response.body)).to eq(JSON.parse({ results: ['json_data', 'json_data'] }.to_json))
      end
    end

    context 'responds with html' do
      before do
        get :show
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'assigns tournament data to @standings' do
        expect(assigns(:standings)).to eq(tournament_ranking_double.determine_rankings)
      end
    end
  end
end
