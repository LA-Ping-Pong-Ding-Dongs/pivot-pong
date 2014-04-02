require 'spec_helper'

describe PlayersController do

  let(:player) { PlayerStruct.new('bob', 'Bob', 1200, 50) }
  let(:nemesis) { PlayerStruct.new('sally', 'Sally', 1500, 150) }
  let(:player_finder_double) { double(PlayerFinder, find: player, find_all_players: [player, nemesis]) }
  let(:match_finder_double) { double(MatchFinder, find_all_for_player: 'all matches', find_recent_matches_for_player: 'recent matches') }
  let(:player_presenter_double) { double(PlayerPresenter, as_json: { field: 'val' }) }
  let(:players_json_presenter_double) { double(PlayersJsonPresenter, as_json: true) }

  before do
    allow(controller).to receive(:player_finder).and_return(player_finder_double)
    allow(controller).to receive(:match_finder).and_return(match_finder_double)
    allow(controller).to receive(:player_presenter).with(player, 'all matches', 'recent matches').and_return(player_presenter_double)
    allow(controller).to receive(:players_json_presenter).with([player, nemesis]).and_return(players_json_presenter_double)
  end

  describe '#show' do
    context 'js request' do
      it 'returns serialized player information' do
        xhr :get, :show, key: 'bob'

        expect(response).to be_success
        expect(JSON(response.body).deep_symbolize_keys).to eq({results: {field: 'val'}})
      end
    end
  end

  describe '#index' do
    context 'js request' do
      it 'returns the players' do
        expect(players_json_presenter_double).to receive(:as_json).and_return([{wut: 'wat'}])
        xhr :get, :index

        expect(response).to be_success
        expect(JSON(response.body).map(&:deep_symbolize_keys)).to match_array([{wut: 'wat'}])
      end
    end
  end
end
