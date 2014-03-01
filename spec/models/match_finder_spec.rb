require 'spec_helper'

describe MatchFinder do
  let!(:winning_match) { Match.create(winner_key: 'bob', loser_key: 'loser', created_at: 4.days.ago) }
  let!(:not_relevant_match) { Match.create(winner_key: 'champ', loser_key: 'loser', created_at: 3.minutes.ago) }
  let!(:losing_match) { Match.create(winner_key: 'champ', loser_key: 'bob', created_at: 2.days.ago) }

  subject(:match_finder) { MatchFinder.new }

  describe '#find_all_for_player' do
    it 'returns all matches for player sorted by created_at time' do
      expect(match_finder.find_all_for_player('bob')).to eq [OpenStruct.new(losing_match.attributes), OpenStruct.new(winning_match.attributes)]
    end
  end
end