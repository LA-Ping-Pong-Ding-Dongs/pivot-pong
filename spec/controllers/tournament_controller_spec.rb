require 'spec_helper'

describe TournamentController do
  let :service do
    double(:service, {
      tournament_rankings: 'data'
    })
  end

  before do
    allow(controller).to receive(:service).and_return(service)
  end

  describe '#show' do
    context 'responds with json' do
      it 'returns current tournament data' do
        xhr :get, :show
        expect(response).to be_success
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
        expect(assigns(:standings)).to eq(service.tournament_rankings)
      end
    end
  end
end
