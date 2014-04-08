require 'spec_helper'

describe RatingsUpdater do
  let(:ratings_updater) { RatingsUpdater.new(player_finder_double, player_updater_double) }

  let(:winner) { PlayerStruct.new('fe6467411b7b93fc5dfca7b8fa715a7d', 'Winner', 1233, 12) }
  let(:loser) { PlayerStruct.new('e8bd17d7852ffa79a687933d1bfdac5a', 'Loser', 445, 233) }
  let(:winner_rating) { double(Saulabs::TrueSkill::Rating, mean: 3454.45, deviation: 32.86) }
  let(:loser_rating) { double(Saulabs::TrueSkill::Rating, mean: 433, deviation: 12) }
  let(:factor_graph_double) { double(Saulabs::TrueSkill::FactorGraph, update_skills: true)}
  let(:player_updater_double) { double(PlayerUpdater) }
  let(:player_finder_double) { double(PlayerFinder) }

  describe '#update_for_match' do
    it 'updates player rating with TrueSkill calculation' do
      expect(player_finder_double).to receive(:find).with(winner.key).and_return(winner)
      expect(player_finder_double).to receive(:find).with(loser.key).and_return(loser)

      expect(Saulabs::TrueSkill::Rating).to receive(:new).with(1233, 12).and_return(winner_rating)
      expect(Saulabs::TrueSkill::Rating).to receive(:new).with(445, 233).and_return(loser_rating)
      expect(Saulabs::TrueSkill::FactorGraph).to receive(:new).with({[winner_rating] => 1, [loser_rating] => 2}).and_return(factor_graph_double)
      expect(factor_graph_double).to receive(:update_skills)
      expect(player_updater_double).to receive(:update_for_player).with(winner.key, { mean: 3454, sigma: 33 } )
      expect(player_updater_double).to receive(:update_for_player).with(loser.key, { mean: 433, sigma: 12 } )

      ratings_updater.update_for_match(winner_key: winner.key, loser_key: loser.key)
    end
  end
end