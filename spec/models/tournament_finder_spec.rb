require 'spec_helper'

describe TournamentFinder do

  subject(:finder) { TournamentFinder.new }

  describe '#find_wins_for_player' do
    let!(:tournament) { Tournament.create(start_date: 3.weeks.ago, end_date: 2.weeks.ago, winner_key: 'bob') }
    let!(:not_relevant_tournament) { Tournament.create(start_date: 3.weeks.ago, end_date: 2.weeks.ago, winner_key: 'sally') }

    it 'returns an array of tournaments for a player' do
      expect(finder.find_wins_for_player('bob')).to match_array([tournament])
    end
  end

  describe '#find_most_recent_tournament' do

    context 'with tournaments' do
      let!(:old_tournament) { Tournament.create(start_date: 3.weeks.ago, end_date: 2.weeks.ago - 1.minute, winner_key: 'bob') }
      let!(:new_tournament) { Tournament.create(start_date: 2.weeks.ago, end_date: 1.weeks.ago, winner_key: 'sally') }

      it 'returns only the most recent tournament' do
        expect(finder.find_most_recent_tournament).to eq(new_tournament)
      end
    end

    context 'without tournaments' do
      it 'raises an error if there are recent tournaments' do
        expect {
          finder.find_most_recent_tournament
        }.to raise_error(TournamentFinder::NoTournamentFound)
      end
    end
  end
end
