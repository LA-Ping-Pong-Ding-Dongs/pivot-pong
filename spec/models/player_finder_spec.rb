require 'spec_helper'

describe PlayerFinder do
  subject(:finder) { PlayerFinder.new(player_creator_double) }

  let(:player) { PlayerStruct.new('sally', 'Sally', 1223, 23) }
  let(:player_creator_double) { double(PlayerCreator, create_player: player )}

  describe '#find_or_create_by_name' do

    context 'when the player does exist' do
      let!(:bob) { Player.create(key: 'bob', name: 'Bob') }

      it 'returns the player struct' do
        expect(finder.find_or_create_by_name('Bob')).to eq build_player_struct(bob)
      end

      it 'does not effect the number of players' do
        expect { finder.find_or_create_by_name('bob') }.to_not change(Player, :count)
      end
    end

    context 'when the name does not exist' do
      it 'creates a record for the player' do
        expect(player_creator_double).to receive(:create_player).with(key: 'sally', name: 'Sally')

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

    let!(:bob) { Player.create(key: 'bob', name: 'Bob') }
    let!(:sally) { Player.create(key: 'sally', name: 'Sally') }
    let!(:templeton) { Player.create(key: 'templeton', name: 'Templeton') }

    it 'returns an array of structs containing all players' do
      expect(finder.find_all_players).to match_array([
                                                         build_player_struct(bob),
                                                         build_player_struct(sally),
                                                         build_player_struct(templeton),
                                                     ])
    end
  end

  describe '#find_players_by_substring' do
    let!(:bob) { Player.create(key: 'bob', name: 'Bob') }
    let!(:shelby) { Player.create(key: 'shelby', name: 'Shelby') }
    let!(:bella) { Player.create(key: 'bella', name: 'Bella') }
    let!(:sally) { Player.create(key: 'sally', name: 'sally') }


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
  end

  describe '#find' do
    let!(:bob) { Player.create(key: 'bob', name: 'Bob') }

    it 'returns an open struct of player data if the player can be found' do
      player_record = finder.find('bob')
      expect(player_record).to eq build_player_struct(bob)
    end

    it 'raises an exception if a player cant be found' do
      expect { finder.find('ashdlfkj') }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

end
