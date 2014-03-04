require 'spec_helper'

describe PlayerFinder do
  subject(:finder) { PlayerFinder.new }

  describe '#find_or_create_by_name' do

    context 'when the player does exist' do
      let!(:bob) { FactoryGirl.create :player, name: 'Bob' }

      it 'returns the player struct' do
        expect(finder.find_or_create_by_name('Bob')).to eq bob.to_struct
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
        player_record = finder.find_or_create_by_name('Sally')

        expect(player_record).to be_kind_of ReadOnlyStruct
        expect(player_record.name).to eq 'Sally'
        expect(player_record.key).to eq 'sally'
      end
    end

    it 'finds the same record regardless of case' do
      lowercase = finder.find_or_create_by_name('bob')
      uppercase = finder.find_or_create_by_name('Bob')
      expect(lowercase).to eq(uppercase)
    end

  end

  describe '#find_all_players' do

    let!(:bob) { FactoryGirl.create(:player, name: 'Bob') }
    let!(:sally) { FactoryGirl.create(:player, name: 'Sally') }
    let!(:templeton) { FactoryGirl.create(:player, name: 'Templeton') }

    it 'returns an array of structs containing all players' do
      expect(finder.find_all_players).to match_array([bob.to_struct, sally.to_struct, templeton.to_struct])
    end

  end

  describe '#find' do

    let!(:bob) { FactoryGirl.create :player, name: 'Bob' }

    it 'returns an open struct of player data if the player can be found' do
      player_record = finder.find('bob')
      expect(player_record).to eq(bob.to_struct)
    end

    it 'raises an exception if a player cant be found' do
      expect { finder.find('ashdlfkj') }.to raise_exception(ActiveRecord::RecordNotFound)
    end

  end

end
