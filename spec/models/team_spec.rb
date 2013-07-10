require 'spec_helper'

describe Team do
  describe 'Validations' do
    it 'must have a name' do
      build(:team, :name => nil).should be_valid
      build(:team, :name => 'a').should be_valid
    end

    it 'name must be unique' do
      create(:team, :name => 'a')
      build(:team, :name => 'a').should_not be_valid

      create(:team, :name => 'B')
      build(:team, :name => 'b').should_not be_valid
    end
  end

  describe '#to_s' do
    it 'returns the players display names when the team name is blank' do
      build(:team,
        :name => nil,
        :player1 => build(:player, :name => 'Pinky'),
        :player2 => build(:player, :name => 'The Brain'),
      ).to_s.should == 'Pinky & The Brain'
    end

    it 'returns the team name when the name is present' do
      build(:team, name: 'Great Name').to_s.should == 'Great Name'
    end

    it 'titleizes' do
      build(:team, name: 'great name').to_s.should == 'Great Name'
    end
  end
end
