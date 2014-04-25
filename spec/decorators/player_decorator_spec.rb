require 'spec_helper'

describe PlayerDecorator do
  let(:player) { double(:player) }
  subject { PlayerDecorator.decorate(player) }

  before do
    allow(player).to receive(:key).and_return('player')
    allow(player).to receive(:recent_matches).and_return([
      double(:match, winner_key: 'player', winner_name: 'player', loser_name: 'Loser', human_date: '04/04/2014'),
      double(:match, winner_key: 'champ', winner_name: 'Champ', loser_name: 'player', human_date: '04/03/2014'),
    ])

    allow(player).to receive(:matches).and_return(player.recent_matches)
    allow(player.recent_matches).to receive(:decorate).and_return(player.recent_matches)
  end

  describe '#overall_record_string' do
    it 'returns wins and losses' do
      allow(player).to receive(:winning_matches).and_return([1, 2])
      allow(player).to receive(:losing_matches).and_return([1])
      expect(subject.overall_record_string).to eq '2-1'
    end

    it 'returns 0s for users with no losses' do
      allow(player).to receive(:winning_matches).and_return([1])
      allow(player).to receive(:losing_matches).and_return([])
      expect(subject.overall_record_string).to eq '1-0'
    end
  end

  describe '#overall_winning_percentage' do
    it 'returns the formatted percentage' do
      allow(player).to receive(:winning_matches).and_return([1, 2, 3, 4])
      allow(player).to receive(:matches).and_return([1, 2, 3, 4, 5, 6])
      expect(subject.overall_winning_percentage).to eq '66.7%'
    end
  end

  describe '#name' do
    it 'returns the player name' do
      allow(player).to receive(:name).and_return('Bob')
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
        expect(subject.streak_count).to eq 1
      end
    end

    context 'player is on losing streak' do
      it 'returns the current losing streak' do
        allow(player).to receive(:matches).and_return([
          double('match', winner_key: 'not player', loser_key: 'player'),
          double('match', winner_key: 'not player', loser_key: 'player'),
          double('match', winner_key: 'not player', loser_key: 'player'),
        ])
        expect(subject.streak_count).to eq 3
      end
    end
  end

  describe '#current_streak_string' do
    it 'returns the an empty string when player has not played a match' do
      allow(player).to receive(:matches).and_return([])
      allow(player).to receive(:recent_matches).and_return([])
      expect(subject.current_streak_string).to eq ''
    end

    it 'delegates to current_streak_count and current_streak_type' do
      expect(subject).to receive(:current_streak_type).and_return('LOSS')
      expect(subject).to receive(:streak_count).and_return(42343)

      expect(subject.current_streak_string).to eq '42343LOSS'
    end
  end

  describe '#current_streak_type' do
    it 'returns W when on a winning streak' do
      allow(player).to receive(:recent_matches).and_return([
        double(:match, winner_key: player.key)
      ])
      expect(subject.current_streak_type).to eq 'W'
    end

    it 'returns L when on a losing streak' do
      allow(player).to receive(:recent_matches).and_return([
        double(:match, winner_key: 'not player')
      ])
      expect(subject.current_streak_type).to eq 'L'
    end

    it 'returns nil when no matches exist' do
      allow(player).to receive(:recent_matches).and_return([ ])
      expect(subject.current_streak_type).to eq nil
    end
  end

  describe '#current_streak_totem_image' do
    it 'returns smoke.png when on a 2 game win streak' do
      allow(subject).to receive(:streak_type).and_return('winner')
      allow(subject).to receive(:streak_count).and_return(2)

      expect(subject.current_streak_totem_image).to eq '/assets/smoke.png'
    end

    it 'returns fire.png when on a 3 game win streak' do
      allow(subject).to receive(:streak_type).and_return('winner')
      allow(subject).to receive(:streak_count).and_return(3)

      expect(subject.current_streak_totem_image).to eq '/assets/fire.png'
    end

    it 'returns ice.png when on a 3 game losing skid' do
      allow(subject).to receive(:streak_type).and_return('loser')
      allow(subject).to receive(:streak_count).and_return(3)

      expect(subject.current_streak_totem_image).to eq '/assets/ice.png'
    end

    it 'returns an empty string at a 2L streak' do
      allow(subject).to receive(:streak_type).and_return('loser')
      allow(subject).to receive(:streak_count).and_return(2)

      expect(subject.current_streak_totem_image).to eq ''
    end

    it 'returns an empty string at a 1W streak' do
      allow(subject).to receive(:streak_type).and_return('winner')
      allow(subject).to receive(:streak_count).and_return(1)

      expect(subject.current_streak_totem_image).to eq ''
    end

    it 'returns an empty string if player has not played a match' do
      allow(subject).to receive(:streak_type).and_return(nil)
      allow(subject).to receive(:streak_count).and_return(nil)

      expect(subject.current_streak_totem_image).to eq ''
    end
  end
end
