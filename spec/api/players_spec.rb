require 'spec_helper'

describe 'Players api' do
  describe 'GET /api/players.js', :show_in_doc do
    it 'renders players', :show_in_doc do
      Player.create name: 'Ehren', mean: 1112, key: 'ehren'
      Player.create name: 'Patrick', mean: 1200, key: 'patrick'
      get api_players_path(format: :json)
      expect(response).to be_success
      expect(response_json).to eq({players: [
        {"name"=>"Ehren", "mean"=>1112, "key"=>"ehren"},
        {"name"=>"Patrick", "mean"=>1200, "key"=>"patrick"}
      ]})
    end
  end

end
