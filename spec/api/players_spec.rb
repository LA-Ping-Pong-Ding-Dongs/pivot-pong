require 'spec_helper'

describe 'Players api' do
  describe 'GET /api/players.js', :show_in_doc do
    let(:ehren_key) { SecureRandom.uuid }
    let(:patrick_key) { SecureRandom.uuid }
    it 'renders players', :show_in_doc do
      Player.create name: 'Ehren', mean: 1112, key: ehren_key
      Player.create name: 'Patrick', mean: 1200, key: patrick_key
      get api_players_path(format: :json)
      expect(response).to be_success
      expect(response_json).to eq({players: [
        {"name"=>"Ehren", "mean"=>1112, "key"=>ehren_key},
        {"name"=>"Patrick", "mean"=>1200, "key"=>patrick_key}
      ]})
    end
  end

end
