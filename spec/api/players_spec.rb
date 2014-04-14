require 'spec_helper'

describe 'Players api' do
  def response_json
    JSON(response.body)
  end

  before :all do
    Player.delete_all
  end

  describe 'GET /players.js', :show_in_doc do
    it 'renders players', :show_in_doc do
      Player.create name: 'Ehren', mean: 1112, key: 'ehren'
      Player.create name: 'Patrick', mean: 1200, key: 'patrick'
      get players_path(format: :js)

      expect(response).to be_success
      expect(response_json).to eq([
        {"name"=>"Ehren", "url"=>"/players/ehren", "mean"=>1112, "key"=>"ehren"},
        {"name"=>"Patrick", "url"=>"/players/patrick", "mean"=>1200, "key"=>"patrick"}
      ])
    end
  end

end
