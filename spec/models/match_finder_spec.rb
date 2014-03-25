require 'spec_helper'

describe MatchFinder do
  let!(:bob) { Player.create(key: 'bob', name: 'Bob') }
  let!(:champ) { Player.create(key: 'champ', name: 'Champ') }
  let!(:loser) { Player.create(key: 'loser', name: 'Loser') }
  let!(:winning_match) { Match.create(winner_key: 'bob', loser_key: 'loser', created_at: 4.days.ago) }
  let!(:not_relevant_match) { Match.create(winner_key: 'champ', loser_key: 'loser', created_at: 3.minutes.ago) }
  let!(:losing_match_1) { Match.create(winner_key: 'champ', loser_key: 'bob', created_at: 2.days.ago) }
  let!(:losing_match_2) { Match.create(winner_key: 'champ', loser_key: 'bob', created_at: 3.months.ago) }

  subject(:match_finder) { MatchFinder.new }

  describe '#find_all_for_player' do
    it 'returns all matches for player sorted by created_at time' do
      expected = [
        build_match_struct(losing_match_1),
        build_match_struct(winning_match),
        build_match_struct(losing_match_2),
      ]
      expect(match_finder.find_all_for_player('bob')).to equal_structs(expected)
    end
  end

  describe '#find_recent_matches_for_player' do
    it 'returns the requested number of matches with player names' do
      expected = [
        build_match_with_names_struct(losing_match_1, 'Champ', 'Bob'),
        build_match_with_names_struct(winning_match, 'Bob', 'Loser'),
      ]
      expect(match_finder.find_recent_matches_for_player('bob', 2)).to equal_structs(expected)
    end
  end

  describe '#find_all' do
    it 'returns all the matches' do
      expected = [
        build_match_with_names_struct(not_relevant_match, 'Champ', 'Loser'),
        build_match_with_names_struct(losing_match_1, 'Champ', 'Bob'),
        build_match_with_names_struct(winning_match, 'Bob', 'Loser'),
        build_match_with_names_struct(losing_match_2, 'Champ', 'Bob'),
      ]
      expect(subject.find_all).to equal_structs(expected)
    end
  end

  describe '#find_matches_for_tournament' do
    it 'returns all matches bound by start and end time' do
      expected = [
        build_match_with_names_struct(not_relevant_match, 'Champ', 'Loser'),
        build_match_with_names_struct(losing_match_1, 'Champ', 'Bob'),
        build_match_with_names_struct(winning_match, 'Bob', 'Loser'),
      ]
      expect(subject.find_matches_for_tournament(5.days.ago, Time.now)).to equal_structs(expected)
    end
  end
end
