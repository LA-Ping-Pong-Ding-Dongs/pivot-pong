require 'spec_helper'

describe MatchUpdater do
  let(:match) { FactoryGirl.create :match }

  subject(:match_updater) { MatchUpdater.new }

  describe '#mark_as_processed' do
    it 'mark the processed field of a match to true' do
      expect(subject.mark_as_processed(match.id)).to eq true
      expect(match.reload).to be_processed
    end
  end
end