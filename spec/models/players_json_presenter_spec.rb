require 'spec_helper'

describe PlayersJsonPresenter do

  let!(:player1) { PlayerStruct.new('bob', 'Bob', 1300, 9) }
  let!(:player2) { PlayerStruct.new('bella', 'Bella', 1100, 8) }
  let!(:player3) { PlayerStruct.new('champy', 'Champy', 1400, 10) }

  subject(:players_json_presenter) do
    PlayersJsonPresenter.new([player1, player2])
  end

  describe '#as_json' do
    it 'presents names of matching players in json format' do
      expect(subject.as_json).to eq([
                                    { key: 'bob', name: 'Bob', url: "/players/bob", mean: 1300 },
                                    { key: 'bella', name: 'Bella', url: "/players/bella", mean: 1100 }
                                    ])
    end

    it 'does not include names of non-matching players in json format' do
      expect(subject.as_json).to_not include( [
                                    { key: 'champy', name: 'Champy' }
                                    ])
    end
  end


end