require 'spec_helper'

describe MatchForm do
  subject(:form) do
    MatchForm.new(
        {winner: 'Bob', loser: 'Sally'},
        player_finder,
        match_creator
    )
  end

  let(:winner) { double(Player, key: 'bob', name: 'Bob') }
  let(:loser) { double(Player, key: 'sally', name: 'Sally') }
  let(:player_finder) { instance_double(PlayerFinder) }
  let(:match_creator) { instance_double(MatchCreator, create_match: nil) }

  describe '#save' do
    it 'creates a match with the winner and the loser' do
      allow(player_finder).to receive(:find_or_create_by_name).with(winner.name).and_return(winner)
      allow(player_finder).to receive(:find_or_create_by_name).with(loser.name).and_return(loser)

      form.save

      expect(match_creator).to have_received(:create_match).with(loser_key: 'sally', winner_key: 'bob')
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