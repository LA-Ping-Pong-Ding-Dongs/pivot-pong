require 'spec_helper'

describe PlayersController do

  let(:player) { PlayerStruct.new('bob', 'Bob', 1200, 50) }
  let(:nemesis) { PlayerStruct.new('sally', 'Sally', 1500, 150) }
  let(:player_finder_double) { double(PlayerFinder, find: player) }
  let(:match_finder_double) { double(MatchFinder, find_all_for_player: 'all matches', find_recent_matches_for_player: 'recent matches') }

  let(:player_info_json_presenter_double) { double(PlayerInfoJsonPresenter, as_json: {field: 'val'}) }

  before do
    allow(controller).to receive(:player_finder).and_return(player_finder_double)
    allow(controller).to receive(:match_finder).and_return(match_finder_double)
    allow(controller).to receive(:player_info_json_presenter).and_return(player_info_json_presenter_double)
  end

  describe '#show' do
    context 'js request' do
      let(:make_request) { xhr :get, :show, key: 'bob' }

      it 'returns serialized player information' do
        make_request
        expect(response).to be_success
        expect(JSON(response.body).deep_symbolize_keys).to eq({results: {field: 'val'}})
      end
    end
  end

end
