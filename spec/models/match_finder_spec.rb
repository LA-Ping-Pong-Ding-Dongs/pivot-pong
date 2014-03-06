require 'spec_helper'

describe MatchFinder do
  let!(:bob) { Player.create(key: 'bob', name: 'Bob') }
  let!(:champ) { Player.create(key: 'champ', name: 'Champ') }
  let!(:loser) { Player.create(key: 'loser', name: 'Loser') }
  let!(:winning_match) { Match.create(winner_key: 'bob', loser_key: 'loser', created_at: 4.days.ago, processed: true) }
  let!(:not_relevant_match) { Match.create(winner_key: 'champ', loser_key: 'loser', created_at: 3.minutes.ago, processed: false) }
  let!(:losing_match_1) { Match.create(winner_key: 'champ', loser_key: 'bob', created_at: 2.days.ago, processed: false) }
  let!(:losing_match_2) { Match.create(winner_key: 'champ', loser_key: 'bob', created_at: 3.months.ago, processed: true) }

  let(:losing_match_1_attrs) do
    {
        id: losing_match_1.id,
        created_at: losing_match_1.created_at,
        winner_name: 'Champ',
        loser_name: 'Bob',
        winner_key: 'champ',
        loser_key: 'bob',
    }
  end


  let(:losing_match_2_attrs) do
    {
        id: losing_match_2.id,
        created_at: losing_match_2.created_at,
        winner_name: 'Champ',
        loser_name: 'Bob',
        winner_key: 'champ',
        loser_key: 'bob',
    }
  end

  let(:not_relevant_match_attrs) do
    {
        id: not_relevant_match.id,
        created_at: not_relevant_match.created_at,
        winner_name: 'Champ',
        loser_name: 'Loser',
        winner_key: 'champ',
        loser_key: 'loser',
    }
  end

  let(:winning_match_attrs) do
    {
        id: winning_match.id,
        created_at: winning_match.created_at,
        winner_name: 'Bob',
        loser_name: 'Loser',
        winner_key: 'bob',
        loser_key: 'loser',
    }
  end

  subject(:match_finder) { MatchFinder.new }

  describe '#find_all_for_player' do
    it 'returns all matches for player sorted by created_at time' do
      expect(match_finder.find_all_for_player('bob')).to eq [losing_match_1.to_struct, winning_match.to_struct, losing_match_2.to_struct]
    end
  end

  describe '#find_recent_matches_for_player' do
    it 'returns the requested number of matches with player names' do

      expect(match_finder.find_recent_matches_for_player('bob', 2)).to eq [ReadOnlyStruct.new(losing_match_1_attrs),
                                                                           ReadOnlyStruct.new(winning_match_attrs)]
    end
  end

  describe '#find_unprocessed' do
    it 'returns all the matches that have not been processed' do
      expect(subject.find_unprocessed).to eq([ReadOnlyStruct.new(not_relevant_match_attrs),
                                              ReadOnlyStruct.new(losing_match_1_attrs)])
    end
  end

  describe '#find_all' do
    it 'returns all the matches' do
      expect(subject.find_all).to eq([ReadOnlyStruct.new(not_relevant_match_attrs),
                                      ReadOnlyStruct.new(losing_match_1_attrs),
                                      ReadOnlyStruct.new(winning_match_attrs),
                                      ReadOnlyStruct.new(losing_match_2_attrs)])
    end
  end
end
