require 'spec_helper'

describe TournamentCreator do
  subject(:creator) { TournamentCreator.new }

  let (:start_time) { DateTime.new(2014, 1, 15) }
  let (:end_time) { DateTime.new(2014, 1, 22) }

  describe '#create_tournament(start_time, end_time, winner_key)' do
    it 'adds a tournament record with a start time, end time, and winner' do
      expect {
        creator.create_tournament(start_time: start_time, end_time: end_time, winner_key: 'sally')
      }.to change(Tournament, :count).by(1)

      expect(Tournament.last.start_time).to eq(start_time)
      expect(Tournament.last.end_time).to eq(end_time)
      expect(Tournament.last.winner_key).to eq('sally')
    end

    it 'returns an Open Struct representing the tournament' do
      record = creator.create_tournament(start_time: DateTime.new(2014, 2, 15), end_time: DateTime.new(2014, 2, 22), winner_key: 'sally')
      expect(record).to be_kind_of TournamentStruct
      expect(record.start_time).to eq(DateTime.new(2014, 2, 15))
      expect(record.end_time).to eq(DateTime.new(2014, 2, 22))
      expect(record.winner_key).to eq('sally')
    end

    it 'raises argument error if any of the three arguments are missing' do
      expect{
        creator.create_tournament
      }.to raise_error(ArgumentError)
    end
  end
end
