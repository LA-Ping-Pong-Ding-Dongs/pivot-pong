require 'spec_helper'

describe MatchCreator do
  subject(:creator) { MatchCreator.new }

  describe '#create_match(winner, loser)' do
    it 'adds a match record with the winner and loser' do
      expect {
        creator.create_match(winner_key: '99ce27141314607c8d0d3cec9807c67f', loser_key: 'abfa9dba916f2e487d64ccdb658ce6d0')
      }.to change(Match, :count).by(1)

      expect(Match.last.winner_key).to eq('99ce27141314607c8d0d3cec9807c67f')
      expect(Match.last.loser_key).to eq('abfa9dba916f2e487d64ccdb658ce6d0')
    end

    it 'returns an Open Struct representing the match' do
      record = creator.create_match(winner_key: 'abfa9dba916f2e487d64ccdb658ce6d0', loser_key: '9621b65bf7c398ee7fd4a708a8171a54')
      expect(record).to be_kind_of MatchStruct
      expect(record.winner_key).to eq 'abfa9dba916f2e487d64ccdb658ce6d0'
      expect(record.loser_key).to eq '9621b65bf7c398ee7fd4a708a8171a54'
    end

    it 'raises argument error if any of the arguments are missing' do
      expect{
        creator.create_match
      }.to raise_error(ArgumentError)
    end
  end
end
