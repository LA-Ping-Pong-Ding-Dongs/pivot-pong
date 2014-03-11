require 'spec_helper'

describe PlayerInfoJsonPresenter do

  let(:player) {PlayerStruct.new('chokester', 'Chokester', 1100, 9) }
  let(:matches) do
    [
        MatchStruct.new(1, 'chokester', 'loser', Time.now),
        MatchStruct.new(1, 'champ', 'chokester', Time.now),
        MatchStruct.new(1, 'champ', 'chokester', Time.now)
    ]
  end

  subject(:player_info_json_presenter) do
    PlayerInfoJsonPresenter.new(player, matches)
  end

  describe '#as_json' do
    it 'presents name, overall_wins, overall_losses and rating in json format' do
      expect(subject.as_json).to eq({
                                        name: 'Chokester',
                                        overall_wins: 1,
                                        overall_losses: 2,
                                        rating: 1100,
                                        overall_win_percentage: '33.3%',
                                    })
    end
  end

  describe '#overall_win_percentage' do
    it 'returns a formatted winning percentage' do
      expect(subject.overall_win_percentage).to eq '33.3%'
    end
  end

  describe '#overall_wins' do
    it 'returns number of losses from all matches' do
      expect(subject.overall_wins).to eq 1
    end
  end

  describe '#overall_losses' do
    it 'returns number of losses from all matches' do
      expect(subject.overall_losses).to eq 2
    end
  end
end
