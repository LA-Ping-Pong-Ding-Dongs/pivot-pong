require 'spec_helper'

describe 'Players api' do
  let(:params) do
    { match: {
      winner: 'patrick',
      loser: 'britz'
    } }
  end

  describe 'POST /api/matches.json' do

    let(:bad_params) do
      { match: {
        winner: 'patrick',
        loser: 'patrick'
      } }
    end

    it 'creates a match', :show_in_doc do
      post api_matches_path(format: :json), params
      expect(response_json).to eq(:winner=>"patrick", :loser=>"britz")
    end

    it 'handles invalid matches', :show_in_doc do
      post api_matches_path(format: :json), bad_params
      expect(response.code).to eq('422')
    end
  end

  describe 'GET /api/matches.json' do
    before { MatchFactory.new(winner: 'Player', loser: 'Not player').save }
    it 'returns json', :show_in_doc do
      get api_matches_path(format: :json)
      expect(response).to be_success
    end
  end
end
