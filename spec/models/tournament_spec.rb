require 'spec_helper'

describe Tournament do
  describe '#initialize' do
    context 'given a start date, end date, and winner' do
      let(:start_date) { 3.weeks.ago }
      let(:end_date) { 2.weeks.ago }
      let(:winner_key) { 'alice' }
      subject { Tournament.new(start_date, end_date, winner_key) }

      it 'creates a new Tournament for that time frame with that winner' do
        expect(subject.start_date).to eq start_date
        expect(subject.end_date).to eq end_date
        expect(subject.winner_key).to eq winner_key
      end
    end
  end
end
