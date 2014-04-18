require 'spec_helper'

describe TournamentCreator do
  subject(:creator) { TournamentCreator.new }

  let (:start_date) { DateTime.new(2014, 1, 15) }
  let (:end_date) { DateTime.new(2014, 1, 22) }

  describe '#create_tournament(start_date, end_date, winner_key)' do
    it 'adds a tournament record with a start time, end time, and winner' do
      expect {
        creator.create_tournament(start_date: start_date, end_date: end_date, winner_key: 'sally')
      }.to change(TournamentRecord, :count).by(1)

      expect(TournamentRecord.last.start_date).to eq(start_date)
      expect(TournamentRecord.last.end_date).to eq(end_date)
      expect(TournamentRecord.last.winner_key).to eq('sally')
    end

    it 'returns a populated instance of Tournament' do
      tournament = creator.create_tournament(start_date: DateTime.new(2014, 2, 15), end_date: DateTime.new(2014, 2, 22), winner_key: 'sally')
      expect(tournament).to be_kind_of Tournament
      expect(tournament.start_date).to eq(DateTime.new(2014, 2, 15))
      expect(tournament.end_date).to eq(DateTime.new(2014, 2, 22))
      expect(tournament.winner_key).to eq('sally')
    end

    it 'raises argument error if any of the three arguments are missing' do
      expect{
        creator.create_tournament
      }.to raise_error(ArgumentError)
    end
  end
end
