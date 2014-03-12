require 'spec_helper'

describe MatchJsonPresenter do
  let(:match_time) { 1.hour.ago }
  let(:match) { MatchWithNamesStruct.new(34, 'bob', 'templeton', 'Bob', 'Templeton', match_time) }

  subject { MatchJsonPresenter.new(match) }

  describe '#as_json' do
    it 'returns match data as JSON' do
      expect(subject.as_json).to eq match.to_h.merge({human_readable_time: '1 hour ago'})
    end
  end

  describe 'human readable time formatting' do
    context 'match time within last day' do
      it 'returns a "time ago" formatted time' do
        expect(subject.as_json[:human_readable_time]).to eq '1 hour ago'
      end
    end

    context 'match time more than a day ago' do
      let(:match_time) { Date.new(2013, 3, 6).to_time }

      it 'returns the formatted date' do
        expect(subject.as_json[:human_readable_time]).to eq '3/6/2013'
      end
    end
  end
end
