require 'spec_helper'

describe TournamentFinder do

  subject(:finder) { TournamentFinder.new }

  describe '#find_wins_for_player' do
    let!(:tournament) { Tournament.create(start_time: 3.weeks.ago, end_time: 2.weeks.ago, winner_key: 'bob') }
    let!(:not_relevant_tournament) { Tournament.create(start_time: 3.weeks.ago, end_time: 2.weeks.ago, winner_key: 'sally') }

    it 'returns an array of tournaments for a player' do
      expect(finder.find_wins_for_player('bob')).to eq([build_tournament_struct(tournament)])
    end
  end

end