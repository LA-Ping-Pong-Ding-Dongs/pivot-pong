require 'spec_helper'

describe PlayerRatingUpdater do

  let(:player) { FactoryGirl.build :player, name: 'Bob', key: 'bob', mean: 1200, sigma: 50 }
  let(:player_finder_double) { double(PlayerFinder, find_all_players: [player.to_struct]) }

  let(:match_1) { FactoryGirl.build :match, id: 1, processed: false }
  let(:match_finder_double) { double(MatchFinder, find_unprocessed: [match_1.to_struct] ) }

  let(:param_builder_double) { double(NttrsParamBuilder, build_player_data: 'playerstuff', build_match_data: 'matchstuff')}

  let(:player_updater_double) { double(PlayerUpdater, update_for_player: nil) }
  let(:match_updater_double) { double(MatchUpdater, mark_as_processed: nil) }

  subject { PlayerRatingUpdater.new(match_finder_double, player_finder_double, param_builder_double, player_updater_double, match_updater_double) }

  describe '#update_for_tournament' do
    pending 'updates player stats with the NTTRS gem' do
      subject.update_for_tournament

      expect(match_finder_double).to have_received(:find_unprocessed)
      expect(player_updater_double).to have_received(:update_for_player).with('bob', { sigma: 5, mean: 1300 })
      expect(match_updater_double).to have_received(:mark_as_processed).with(1)
    end
  end
end
