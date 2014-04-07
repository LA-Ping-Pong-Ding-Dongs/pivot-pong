require 'spec_helper'

describe PlayersController do

  let(:player) { PlayerStruct.new('f2b8be6ba879e2b1bd1653852f1a33ab', 'Bob', 1200, 50) }
  let(:nemesis) { PlayerStruct.new('99ce27141314607c8d0d3cec9807c67f', 'Sally', 1500, 150) }

  let(:player_finder_double) { double(PlayerFinder, find: player, find_all_players: [player, nemesis]) }
  let(:match_finder_double) { double(MatchFinder, find_all_for_player: 'all matches', find_recent_matches_for_player: 'recent matches') }
  let(:tournament_finder_double) { double(TournamentFinder, find_wins_for_player: 'tournament wins') }

  let(:player_presenter_double) { double(PlayerPresenter, as_json: { field: 'val' }) }
  let(:players_json_presenter_double) { double(PlayersJsonPresenter, as_json: true) }

  let(:bella) { PlayerStruct.new('93fb9466661fe0da4f07df6a745ffb81', 'Bella', 1200, 100) }
  let(:single_player_finder_double) { double(PlayerFinder, find: bella) }

  before do
    allow(controller).to receive(:player_finder).and_return(player_finder_double)
    allow(controller).to receive(:match_finder).and_return(match_finder_double)
    allow(controller).to receive(:tournament_finder).and_return(tournament_finder_double)

    allow(controller).to receive(:player_presenter).with(player, 'all matches', 'recent matches', 'tournament wins').and_return(player_presenter_double)
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

    context 'html request' do
      it 'successfully renders the player show page' do
        get :show, key: 'bob'

        expect(response).to be_success
        expect(assigns[:player_information]).to eq player_presenter_double
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

  describe '#edit' do
    before do
      allow(controller).to receive(:player_finder).and_return(single_player_finder_double)
      allow(controller).to receive(:player_presenter).with(bella, nil, nil, nil).and_return(single_player_finder_double)
    end
    context 'js request' do
      it 'renders a player name edit form' do
        xhr :get, :edit, key: bella.key

        expect(response).to be_success
      end
    end
  end

  describe '#update' do
    let(:templeton) { Player.create(key: '6ce6380961f7b389e51a4080767f9aeb', name: 'Templeton') }

    context 'js response' do
      it 'redirects to player page on success' do
        xhr :patch, :update, key: templeton.key, player: { name: 'Mallomar' }
        expect(response).to redirect_to player_path templeton.key
      end

      it 'renders edit with errors if save fails' do
        xhr :patch, :update, key: templeton.key, player: { name: 'Templeton' }
        expect(response).to redirect_to edit_player_path(templeton.key)
      end
    end
  end
end
