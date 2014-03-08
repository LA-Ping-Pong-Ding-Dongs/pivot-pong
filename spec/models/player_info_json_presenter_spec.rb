require 'spec_helper'

describe PlayerInfoJsonPresenter do

  let(:player) { FactoryGirl.build(:player, name: 'Chokester', key: 'chokester', mean: 1100) }
  let(:matches) do
    [
        Match.new(winner_key: 'chokester', loser_key: 'loser').to_struct,
        Match.new(winner_key: 'champ', loser_key: 'chokester').to_struct,
        Match.new(winner_key: 'champ', loser_key: 'chokester').to_struct,
    ]
  end

  subject(:player_info_json_presenter) do
    PlayerInfoJsonPresenter.new(player, matches)
  end

  describe '#as_json' do
    it 'presents name, overall_wins, overall_losses and rating in json format' do
      expect(subject.as_json).to eq({ name: 'Chokester', overall_wins: 1, overall_losses: 2, rating: 1100 })
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
