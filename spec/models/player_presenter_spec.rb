require 'spec_helper'

describe PlayerPresenter do

  let(:bob) { OpenStruct.new(name: 'Bob', key: 'bob') }
  let(:loser) { OpenStruct.new(name: 'Loser', key: 'loser') }
  let(:champ) { OpenStruct.new(name: 'Champ', key: 'champ') }

  let(:april_1) { DateTime.new(2014, 04, 01) }
  let(:april_3) { DateTime.new(2014, 04, 03) }
  let(:april_4) { DateTime.new(2014, 04, 04) }

  let(:winning_match_1) { OpenStruct.new(winner_key: bob.key, loser_key: loser.key, created_at: april_1) }
  let(:winning_match_2) { OpenStruct.new(winner_key: bob.key, loser_key: loser.key, created_at: april_4) }
  let(:losing_match) { OpenStruct.new(winner_key: champ.key, loser_key: bob.key, created_at: april_3) }

  let(:player_finder_double) { double(PlayerFinder) }

  subject(:player_presenter) { PlayerPresenter.new(bob, [winning_match_2, losing_match, winning_match_1], player_finder_double) }

  before do
    allow(player_finder_double).to receive(:find) do |key|
      OpenStruct.new(name: key.camelize, key: key)
    end
  end

  describe '#overall_record' do
    it 'returns wins and losses' do
      expect(subject.overall_record).to eq '2-1'
    end

    it 'returns 0s for users with no losses' do
      player_presenter = PlayerPresenter.new(champ, [losing_match])
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
      expect(subject.recent_matches).to eq ['Beat Loser on 04/04/2014', 'Lost to Champ on 04/03/2014', 'Beat Loser on 04/01/2014']
    end

    it 'limits the matches to the RECENT_MATCH_LIMIT' do
      recent_match_limit = PlayerPresenter::RECENT_MATCH_LIMIT
      Kernel.silence_warnings do
        PlayerPresenter::RECENT_MATCH_LIMIT = 2
      end

      expect(subject.recent_matches).to eq ['Beat Loser on 04/04/2014', 'Lost to Champ on 04/03/2014']

      Kernel.silence_warnings do
        PlayerPresenter::RECENT_MATCH_LIMIT = recent_match_limit
      end
    end
  end
end