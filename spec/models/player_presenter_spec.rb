require 'spec_helper'

describe PlayerPresenter do

  let(:bob) { PlayerStruct.new('bob', 'Bob', 1200, 50) }
  let(:loser) { PlayerStruct.new('loser', 'Loser', 1200, 50) }
  let(:champ) { PlayerStruct.new('champ', 'Champ', 1200, 50) }

  let(:april_1) { DateTime.new(2014, 04, 01) }
  let(:april_3) { DateTime.new(2014, 04, 03) }
  let(:april_4) { DateTime.new(2014, 04, 04) }

  let(:winning_match_1) { MatchStruct.new(2, bob.key, loser.key, april_1) }
  let(:winning_match_2) { MatchStruct.new(3, bob.key, loser.key, april_4) }
  let(:losing_match) { MatchStruct.new(4, champ.key, bob.key, april_3) }

  let(:all_matches) { [winning_match_2, losing_match, winning_match_1] }
  let(:recent_matches) do
    [
        build_match_with_names_struct(winning_match_2, 'Bob', 'Loser'),
        build_match_with_names_struct(losing_match, 'Champ', 'Bob'),
    ]
  end

  let(:player_finder_double) { double(PlayerFinder) }

  subject(:player_presenter) { PlayerPresenter.new(bob, all_matches, recent_matches, player_finder_double) }

  before do
    allow(player_finder_double).to receive(:find) do |key|
      PlayerStruct.new(key, key.camelize, 1200, 50)
    end
  end

  describe '#overall_record' do
    it 'returns wins and losses' do
      expect(subject.overall_record).to eq '2-1'
    end

    it 'returns 0s for users with no losses' do
      player_presenter = PlayerPresenter.new(champ, [losing_match], [])
      expect(player_presenter.overall_record).to eq '1-0'
    end
  end

  describe '#overall_winning_percentage' do
    it 'returns the formatted percentage' do
      expect(subject.overall_winning_percentage).to eq '66.7%'
    end
  end

  describe '#name' do
    it 'returns the player name' do
      expect(subject.name).to eq 'Bob'
    end
  end

  describe '#recent_matches' do
    it 'returns an array of human-readable strings' do
      expect(subject.recent_matches).to eq ["#{I18n.t('player.recent_matches.won')} Loser on 04/04/2014", "#{I18n.t('player.recent_matches.lost')} Champ on 04/03/2014"]
    end
  end
end