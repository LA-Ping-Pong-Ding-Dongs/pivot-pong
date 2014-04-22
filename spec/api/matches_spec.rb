require 'spec_helper'

describe 'Players api' do
  describe 'GET /api/matches.json' do
    let(:params) do
      { match: {
        winner: 'patrick',
        loser: 'britz'
      } }
    end

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
      expect(response.code).to eq('400')
    end
  end

  describe 'POST /api/matches.json', :show_in_doc do
  end
end
