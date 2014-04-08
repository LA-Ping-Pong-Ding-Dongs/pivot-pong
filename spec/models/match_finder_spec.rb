require 'spec_helper'

describe MatchFinder do
  let!(:bob) { Player.create(key: '9621b65bf7c398ee7fd4a708a8171a54', name: 'Bob') }
  let!(:champ) { Player.create(key: '99ce27141314607c8d0d3cec9807c67f', name: 'Champ') }
  let!(:loser) { Player.create(key: '544151cd41aaa51edfd4a0bd2ccbef03', name: 'Loser') }
  let!(:winning_match) { Match.create(winner_key: bob.key, loser_key: loser.key, created_at: 4.days.ago).reload }
  let!(:not_relevant_match) { Match.create(winner_key: champ.key, loser_key: loser.key, created_at: 3.minutes.ago).reload }
  let!(:losing_match_1) { Match.create(winner_key: champ.key, loser_key: bob.key, created_at: 2.days.ago).reload }
  let!(:losing_match_2) { Match.create(winner_key: champ.key, loser_key: bob.key, created_at: 3.months.ago).reload }

  subject(:match_finder) { MatchFinder.new }

  describe '#find_all_for_player' do
    it 'returns all matches for player sorted by created_at time' do
      expected = [
        build_match_struct(losing_match_1),
        build_match_struct(winning_match),
        build_match_struct(losing_match_2),
      ]
      expect(match_finder.find_all_for_player(bob.key)).to eq(expected)
    end
  end

  describe '#find_recent_matches_for_player' do
    it 'returns the requested number of matches with player names' do
      expected = [
        build_match_with_names_struct(losing_match_1, 'Champ', 'Bob'),
        build_match_with_names_struct(winning_match, 'Bob', 'Loser'),
      ]
      expect(match_finder.find_recent_matches_for_player(bob.key, 2)).to eq(expected)
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
      expect(subject.find_all).to eq(expected)
    end
  end

  describe '#find_matches_for_tournament' do
    it 'returns all matches bound by start and end time' do
      expected = [
        build_match_with_names_struct(not_relevant_match, 'Champ', 'Loser'),
        build_match_with_names_struct(losing_match_1, 'Champ', 'Bob'),
        build_match_with_names_struct(winning_match, 'Bob', 'Loser'),
      ]
      expect(subject.find_matches_for_tournament(5.days.ago, Time.now)).to eq(expected)
    end

    it 'returns a limited amount of matches if limit specified' do
      expected = [
        build_match_with_names_struct(not_relevant_match, 'Champ', 'Loser'),
        build_match_with_names_struct(losing_match_1, 'Champ', 'Bob'),
      ]
      expect(subject.find_matches_for_tournament(5.days.ago, Time.now, 2)).to eq(expected)
    end
  end

end