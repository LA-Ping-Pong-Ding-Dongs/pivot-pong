require 'spec_helper'

describe TournamentFinder do

  subject(:finder) { TournamentFinder.new }

  describe '#find_wins_for_player' do
    let(:tournament) { Tournament.new(3.weeks.ago, 2.weeks.ago, 'bob') }
    let(:not_relevant_tournament) { Tournament.new(3.weeks.ago, 2.weeks.ago, 'sally') }
    before do
      [tournament, not_relevant_tournament].each do |t|
        TournamentCreator.new.create_tournament(
          start_date: t.start_date,
          end_date: t.end_date,
          winner_key: t.winner_key)
      end
    end

    it 'returns an array of tournaments for a player' do
      expect(finder.find_wins_for_player('bob')).to match_array([tournament])
    end
  end

  describe '#find_most_recent_tournament' do

    context 'with tournaments' do
      let(:old_tournament) { Tournament.new(3.weeks.ago, 2.weeks.ago - 1.minute, 'bob') }
      let(:new_tournament) { Tournament.new(2.weeks.ago, 1.weeks.ago, 'sally') }
      let(:creator) { TournamentCreator.new }
      before do
        [old_tournament, new_tournament].each do |t|
          creator.create_tournament(
            start_date: t.start_date,
            end_date: t.end_date,
            winner_key: t.winner_key)
        end
      end

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
