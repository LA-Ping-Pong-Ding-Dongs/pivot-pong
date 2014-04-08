require 'spec_helper'

describe PlayersJsonPresenter do

  let!(:player1) { PlayerStruct.new('93fb9466661fe0da4f07df6a745ffb81', 'Bob', 1300, 9) }
  let!(:player2) { PlayerStruct.new('55489db33455c06c6dc2d686e2c03433', 'Bella', 1100, 8) }
  let!(:player3) { PlayerStruct.new('fe6467411b7b93fc5dfca7b8fa715a7d', 'Champy', 1400, 10) }

  subject(:players_json_presenter) do
    PlayersJsonPresenter.new([player1, player2])
  end

  describe '#as_json' do
    it 'presents names of matching players in json format' do
      expect(subject.as_json).to eq([
                                    { key: player1.key, name: 'Bob', url: "/players/#{player1.key}", mean: 1300 },
                                    { key: player2.key, name: 'Bella', url: "/players/#{player2.key}", mean: 1100 }
                                    ])
    end

    it 'does not include names of non-matching players in json format' do
      expect(subject.as_json).to_not include( [
                                    { key: player3.key, name: 'Champy' }
                                    ])
    end
  end


end