require 'spec_helper'

describe PlayerCreator do
  describe 'create_player' do
    it 'creates a player with default mean and sigma' do
      expect { subject.create_player(key: 'key', name: 'Name') }.to change(Player, :count).by(1)

      player_record = Player.last
      expect(player_record.name).to eq 'Name'
      expect(player_record.key).to eq 'key'
      expect(player_record.mean).to eq Player::DEFAULT_MEAN
      expect(player_record.sigma).to eq Player::DEFAULT_SIGMA
    end

    it 'creates a player with a mean and sigma if specified' do
      expect { subject.create_player(key: 'key', name: 'Name', mean: 2311, sigma: 10) }.to change(Player, :count).by(1)

      player_record = Player.last
      expect(player_record.name).to eq 'Name'
      expect(player_record.key).to eq 'key'
      expect(player_record.mean).to eq 2311
      expect(player_record.sigma).to eq 10
    end

    it 'returns a player struct' do
      expect(subject.create_player(key: 'key', name: 'Name')).to eq(PlayerStruct.new('key', 'Name', Player::DEFAULT_MEAN, Player::DEFAULT_SIGMA))
    end
  end
end