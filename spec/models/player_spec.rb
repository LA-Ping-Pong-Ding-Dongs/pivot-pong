require 'spec_helper'

describe Player do
  subject(:player) { Player.new(name: 'Bob', key: 'bob', mean: 2300, sigma: 40, last_tournament_date: 5.weeks.ago.to_date) }

  describe '#to_struct' do
    it 'converts the active record object to a struct' do
      struct = subject.to_struct

      expect(struct).to be_kind_of ReadOnlyStruct
      expect(struct.name).to eq 'Bob'
      expect(struct.key).to eq 'bob'
      expect(struct.mean).to eq 2300
      expect(struct.sigma).to eq 40
      expect(struct.last_tournament_date).to eq 5.weeks.ago.to_date
    end
  end
end