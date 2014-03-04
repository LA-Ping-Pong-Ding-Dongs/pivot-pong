require 'spec_helper'

describe Match do

  subject(:match) { Match.new(winner_key: 'bob', loser_key: 'sally', created_at: created, updated_at: updated) }

  describe '#to_struct' do
    let(:created) { 3.days.ago }
    let(:updated) { 5.minutes.ago }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    it 'converts the active record object to a struct' do
      struct = subject.to_struct

      expect(struct).to be_kind_of ReadOnlyStruct
      expect(struct.winner_key).to eq 'bob'
      expect(struct.loser_key).to eq 'sally'
      expect(struct.created_at).to eq created
      expect(struct.updated_at).to eq updated
    end

  end
end