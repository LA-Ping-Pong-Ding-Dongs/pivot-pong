require 'spec_helper'

describe MatchForm do
  subject(:form) do
    MatchForm.new(
        {winner: 'Bob', loser: 'Sally'},
        player_finder,
        match_creator,
        ratings_updater
    )
  end

  let(:bob) { double(Player, key: '544151cd41aaa51edfd4a0bd2ccbef03', name: 'Bob') }
  let(:sally) { double(Player, key: '9621b65bf7c398ee7fd4a708a8171a54', name: 'Sally') }
  let(:player_finder) { instance_double(PlayerFinder) }
  let(:match_creator) { instance_double(MatchCreator, create_match: nil) }
  let(:ratings_updater) { instance_double(RatingsUpdater, update_for_match: nil) }

  describe '#save' do
    before do
      allow(player_finder).to receive(:find_or_create_by_name).with(bob.name).and_return(bob)
      allow(player_finder).to receive(:find_or_create_by_name).with(sally.name).and_return(sally)
    end

    it 'creates a match with the winner and the loser' do
      form.save

      expect(match_creator).to have_received(:create_match).with(loser_key: sally.key, winner_key: bob.key)
    end

    it 'updates player ratings for players in the match' do
      form.save

      expect(ratings_updater).to have_received(:update_for_match).with(winner_key: bob.key, loser_key: sally.key)
    end
  end

  describe '#winner' do
    it 'exposes the winner parameter' do
      expect(MatchForm.new({winner: 'This Guy!'}).winner).to eq('This Guy!')
    end
  end

  describe '#loser' do
    it 'exposes the loser parameter' do
      expect(MatchForm.new({loser: 'This Girl!'}).loser).to eq('This Girl!')
    end
  end

  describe '#as_json' do
    it 'returns the params' do
      expect(form.as_json).to eq({winner: 'Bob', loser: 'Sally'})
    end
  end
end