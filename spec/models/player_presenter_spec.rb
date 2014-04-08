require 'spec_helper'

describe PlayerPresenter do

  let(:bob) { PlayerStruct.new('dda629140ba03c2e861a248d2c2579cb', 'Bob', 1200, 50) }
  let(:loser) { PlayerStruct.new('99ce27141314607c8d0d3cec9807c67f', 'Loser', 1200, 50) }
  let(:champ) { PlayerStruct.new('f2b8be6ba879e2b1bd1653852f1a33ab', 'Champ', 1200, 50) }

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

  describe '#overall_wins' do
    it 'returns number of losses from all matches' do
      expect(subject.overall_wins).to eq 2
    end
  end

  describe '#overall_losses' do
    it 'returns number of losses from all matches' do
      expect(subject.overall_losses).to eq 1
    end
  end

  describe '#overall_record_string' do
    it 'returns wins and losses' do
      expect(subject.overall_record_string).to eq '2-1'
    end

    it 'returns 0s for users with no losses' do
      player_presenter = PlayerPresenter.new(champ, [losing_match], [])
      expect(player_presenter.overall_record_string).to eq '1-0'
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

  describe '#current_streak_count' do
    context 'player is on winning streak but also has a loss to break up streak' do
      it 'returns the current winning streak' do
        expect(subject.current_streak_count).to eq 1
      end
    end

    context 'player is on losing streak' do
      it 'returns the current losing streak' do
        presenter = PlayerPresenter.new(loser, [winning_match_1, winning_match_2, other_losing_match], [], player_finder_double)
        expect(presenter.current_streak_count).to eq 3
      end
    end

    context 'player is on winning streak' do
      it 'returns the current winning streak' do
        presenter = PlayerPresenter.new(champ, [losing_match, other_losing_match], [], player_finder_double)
        expect(presenter.current_streak_count).to eq 2
      end
    end

    context 'player has not played in a match' do
      it 'returns the an empty string' do
        presenter = PlayerPresenter.new(bob, [], [], player_finder_double)
        expect(presenter.current_streak_count).to eq nil
      end
    end
  end

  describe '#current_streak_string' do
    it 'returns the an empty string when player has not played a match' do
      presenter = PlayerPresenter.new(bob, [], [], player_finder_double)
      expect(presenter.current_streak_string).to eq ''
    end

    it 'delegates to current_streak_count and current_streak_type' do
      expect(subject).to receive(:current_streak_type).and_return('LOSS')
      expect(subject).to receive(:current_streak_count).and_return(42343)

      expect(subject.current_streak_string).to eq '42343LOSS'
    end
  end

  describe '#current_streak_type' do
    it 'returns W when on a winning streak' do
      expect(subject.current_streak_type).to eq 'W'
    end

    it 'returns L when on a losing streak' do
      presenter = PlayerPresenter.new(loser, [winning_match_1, winning_match_2, other_losing_match], [], player_finder_double)
      expect(presenter.current_streak_type).to eq 'L'
    end

    it 'returns nil when no matches exist' do
      presenter = PlayerPresenter.new(loser, [], [], player_finder_double)
      expect(presenter.current_streak_type).to eq nil
    end
  end

  describe '#current_streak_totem_image' do
    it 'returns smoke.png when on a 2 game win streak' do
      expect(subject).to receive(:current_streak_type).and_return('W')
      expect(subject).to receive(:current_streak_count).and_return(2)

      expect(subject.current_streak_totem_image).to eq 'smoke.png'
    end

    it 'returns fire.png when on a 3 game win streak' do
      expect(subject).to receive(:current_streak_type).and_return('W')
      expect(subject).to receive(:current_streak_count).and_return(3)

      expect(subject.current_streak_totem_image).to eq 'fire.png'
    end

    it 'returns ice.png when on a 3 game losing skid' do
      expect(subject).to receive(:current_streak_type).and_return('L')
      expect(subject).to receive(:current_streak_count).and_return(3)

      expect(subject.current_streak_totem_image).to eq 'ice.png'
    end

    it 'returns an empty string at a 2L streak' do
      expect(subject).to receive(:current_streak_type).and_return('L')
      expect(subject).to receive(:current_streak_count).and_return(2)

      expect(subject.current_streak_totem_image).to eq ''
    end

    it 'returns an empty string at a 1W streak' do
      expect(subject).to receive(:current_streak_type).and_return('W')
      expect(subject).to receive(:current_streak_count).and_return(1)

      expect(subject.current_streak_totem_image).to eq ''
    end

    it 'returns an empty string if player has not played a match' do
      expect(subject).to receive(:current_streak_type).and_return(nil)
      expect(subject).to receive(:current_streak_count).and_return(nil)

      expect(subject.current_streak_totem_image).to eq ''
    end
  end

  describe '#as_json' do
    it 'presents name, overall_wins, overall_losses and rating in json format' do
      expect(subject).to receive(:current_streak_totem_image).and_return('fire.bmp')

      expect(subject.as_json).to eq({
                                        name: 'Bob',
                                        overall_wins: 2,
                                        overall_losses: 1,
                                        current_streak_count: 1,
                                        current_streak_type: 'W',
                                        current_streak_totem_image: 'fire.bmp',
                                        rating: 1200,
                                        overall_winning_percentage: '66.7%',
                                    })
    end
  end
end