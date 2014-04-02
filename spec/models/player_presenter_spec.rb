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
  let(:other_losing_match) { MatchStruct.new(4, champ.key, loser.key, april_1) }

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
      expect(subject.recent_matches).to eq ["#{I18n.t('player.recent_matches.won')} Loser #{I18n.t('player.recent_matches.on_date')} 04/04/2014", "#{I18n.t('player.recent_matches.lost')} Champ #{I18n.t('player.recent_matches.on_date')} 04/03/2014"]
    end
  end

  describe '#current_streak' do
    context 'player is on winning streak but also has a loss to break up streak' do
      it 'returns the current winning streak' do
        expect(subject.current_streak).to eq "1#{I18n.t('player.streak.type.winner')}"
      end
    end

    context 'player is on losing streak' do
      it 'returns the current losing streak' do
        presenter = PlayerPresenter.new(loser, [winning_match_1, winning_match_2, other_losing_match], [], player_finder_double)
        expect(presenter.current_streak).to eq "3#{I18n.t('player.streak.type.loser')}"
      end
    end

    context 'player is on winning streak' do
      it 'returns the current winning streak' do
        presenter = PlayerPresenter.new(champ, [losing_match, other_losing_match], [], player_finder_double)
        expect(presenter.current_streak).to eq "2#{I18n.t('player.streak.type.winner')}"
      end
    end

    context 'player has not played in a match' do
      it 'returns the an empty string' do
        presenter = PlayerPresenter.new(bob, [], [], player_finder_double)
        expect(presenter.current_streak).to eq ''
      end
    end
  end
end