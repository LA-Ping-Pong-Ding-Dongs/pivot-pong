require 'spec_helper'

describe PlayersSearchController do
  let(:bob) { PlayerStruct.new('99ce27141314607c8d0d3cec9807c67f', 'Bob', 1200, 50) }
  let(:bally) { PlayerStruct.new('dda629140ba03c2e861a248d2c2579cb', 'Bally', 1500, 150) }
  let(:player_finder_double) { double(PlayerFinder) }
  let(:players_json_presenter_double) { double(PlayersJsonPresenter) }

  before do
    allow(controller).to receive(:player_finder).and_return(player_finder_double)
    allow(controller).to receive(:players_json_presenter).with([bob, bally]).and_return(players_json_presenter_double)
  end

  describe '#index' do
    context 'js request' do
      let(:make_request) { xhr :get, :index, search: 'b' }

      it 'returns serialized player information' do
        expect(player_finder_double).to receive(:find_players_by_substring).with('b').and_return([bob, bally])
        expect(players_json_presenter_double).to receive(:as_json).and_return([{wut: 'wat'}])
        make_request

        expect(response).to be_success
        expect(JSON(response.body).map(&:deep_symbolize_keys)).to match_array([{wut: 'wat'}])
      end
    end
  end
end