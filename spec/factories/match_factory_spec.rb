require 'spec_helper'

describe MatchFactory do
  describe 'valid?' do
    let(:winner) { Player.create name: 'patrick' }
    let(:loser) { Player.create name: 'patrick' }
    it 'is false if the two players are the same' do
      match = MatchFactory.new(winner: winner.name, loser: winner.name)
      expect(match.save).to be_falsy
    end
  end
end
