require 'spec_helper'

describe PlayerFinder do
  subject(:finder) { PlayerFinder.new }

  describe '#find_or_create_by_name' do

    context 'when the player does exist' do
      before { Player.create(name: 'Bob', key: 'bob') }

      it 'returns the player struct' do
        expect(finder.find_or_create_by_name('Bob')).to eq(OpenStruct.new(key: 'bob', name: 'Bob'))
      end

      it 'does not effect the number of players' do
        expect { finder.find_or_create_by_name('bob') }.to_not change(Player, :count)
      end
    end

    context 'when the name does not exist' do
      it 'creates a record for the player' do
        expect { finder.find_or_create_by_name('Sally') }.to change(Player, :count).by(1)
      end

      it 'still returns the player struct' do
        expect(finder.find_or_create_by_name('Sally')).to eq(OpenStruct.new(key: 'sally', name: 'Sally'))
      end
    end

    it 'finds the same record regardless of case' do
      lowercase = finder.find_or_create_by_name('bob')
      uppercase = finder.find_or_create_by_name('Bob')
      expect(lowercase).to eq(uppercase)
    end

  end

  describe '#find_all_players' do

    before do
      Player.create(name: 'Bob', key: 'bob')
      Player.create(name: 'Sally', key: 'sally')
      Player.create(name: 'Templeton', key: 'templeton')
    end

    it 'returns an array of structs containing all players' do
      expected_response = [
          OpenStruct.new(name: 'Bob', key: 'bob'),
          OpenStruct.new(name: 'Sally', key: 'sally'),
          OpenStruct.new(name: 'Templeton', key: 'templeton'),
      ]

      expect(finder.find_all_players).to match_array(expected_response)
    end

  end

  describe '#find' do
    before do
      Player.create(name: 'Bob', key: 'bob')
    end

    it 'returns an open struct of player data if the player can be found' do
      player_record = finder.find('bob')
      expect(player_record.name).to eq 'Bob'
    end

    it 'raises an exception if a player cant be found' do
      expect { finder.find('ashdlfkj') }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

end
