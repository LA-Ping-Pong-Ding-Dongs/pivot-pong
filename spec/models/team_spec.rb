require 'spec_helper'

describe Team do
  describe '#to_s' do
    it 'returns the players display names' do
      build(:team,
        :player1 => build(:player, :name => 'Pinky'),
        :player2 => build(:player, :name => 'The Brain'),
      ).to_s.should == 'Pinky and The Brain'
    end
  end
end
