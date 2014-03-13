require 'spec_helper'

describe PlayerStandingJsonPresenter do

  let(:player_standing) { double(PlayerStanding, {
    key: 'bob',
    name: 'Bob',
    wins: 1,
    losses: 10,
  })}

  subject { PlayerStandingJsonPresenter.new(player_standing) }

  describe '#as_json' do
    it 'returns player data as JSON' do
      expect(subject.as_json).to eq({key: 'bob', name: 'Bob', wins: 1, losses: 10 })
    end
  end

end
