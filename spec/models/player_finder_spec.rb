require 'spec_helper'

describe PlayerFinder do
  subject(:finder) { PlayerFinder.new(player_creator_double) }

  let(:real_finder) { PlayerFinder.new }
  let(:test_key) { 'uuid' }
  let(:player) { PlayerStruct.new(test_key, 'Sally', 1223, 23) }
  let(:player_creator_double) { double(PlayerCreator, create_player: player) }

  describe '#find_or_create_by_name' do

    context 'when the player does exist' do
      let!(:bob) { Player.create(key: SecureRandom.uuid, name: 'Bob') }

      it 'returns the player struct' do
        expect(finder.find_or_create_by_name('Bob')).to eq build_player_struct(bob)
      end

      it 'does not effect the number of players' do
        expect { finder.find_or_create_by_name('bob') }.to_not change(Player, :count)
      end
    end

    context 'when the name does not exist' do

      let(:user_key) { 'the id' }

      it 'creates a record for the player' do
        allow(SecureRandom).to receive(:uuid).and_return(user_key)
        expect(player_creator_double).to receive(:create_player).with(key: user_key, name: 'Sally')

        finder.find_or_create_by_name('Sally')
      end
    end

    it 'finds the same record regardless of case' do
     lowercase = finder.find_or_create_by_name('bob')
     uppercase = finder.find_or_create_by_name('Bob')
      expect(lowercase).to eq(uppercase)
    end

  end

  describe '#find_all_players' do
    let!(:bob) { Player.create(key: SecureRandom.uuid, name: 'Bob') }
    let!(:templeton) { Player.create(key: SecureRandom.uuid, name: 'Templeton') }
    let!(:sally) { Player.create(key: SecureRandom.uuid, name: 'sally') }

    it 'returns an array of structs containing all players in alphabeticsl order' do
      expect(finder.find_all_players).to eq([
                                                         build_player_struct(bob),
                                                         build_player_struct(sally),
                                                         build_player_struct(templeton),
                                                     ])
    end
  end

  describe '#find_players_by_substring' do
    let!(:bob) { Player.create(key: SecureRandom.uuid, name: 'Bob') }
    let!(:shelby) { Player.create(key: SecureRandom.uuid, name: 'Shelby') }
    let!(:bella) { Player.create(key: SecureRandom.uuid, name: 'Bella') }
    let!(:sally) { Player.create(key: SecureRandom.uuid, name: 'sally') }


    it 'returns an alphabetically ordered array of player names matching substring ' do
      expect(finder.find_players_by_substring('b')).to eql([
                                                               build_player_struct(bella),
                                                               build_player_struct(bob),
                                                           ])
    end

    it 'returns a case-insensitive search' do
      expect(finder.find_players_by_substring('s')).to match_array([
                                                                       build_player_struct(sally),
                                                                       build_player_struct(shelby),
                                                                   ])
    end

    it 'returns all players when the substring an empty string' do
      expect(finder.find_players_by_substring('')).to match_array([
                                                             build_player_struct(bella),
                                                             build_player_struct(bob),
                                                             build_player_struct(sally),
                                                             build_player_struct(shelby),
                                                         ])
    end
  end

  describe '#find' do
    let(:bobs_key) { SecureRandom.uuid }
    let!(:bob) { Player.create(key: bobs_key, name: 'Bob') }

    it 'returns an open struct of player data if the player can be found' do
      player_record = finder.find(bobs_key)
      expect(player_record).to eq build_player_struct(bob)
    end

    it 'raises an exception if a player cant be found' do
      expect { finder.find('ashdlfkj') }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

end
