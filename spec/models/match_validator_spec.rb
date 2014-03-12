require 'spec_helper'

describe MatchValidator do

  let(:valid_params) do
    {
        winner: 'Sally',
        loser: 'Templeton',
    }
  end

  it 'is invalid by default' do
    expect(MatchValidator.new({})).to_not be_valid
  end

  it 'can be valid' do
    expect(MatchValidator.new(valid_params)).to be_valid
  end

  describe 'to be valid' do
    it 'must have a winner present' do
      expect(MatchValidator.new(valid_params.merge(winner: nil))).to_not be_valid
      expect(MatchValidator.new(valid_params.merge(winner: ''))).to_not be_valid
    end

    it 'must have a loser present' do
      expect(MatchValidator.new(valid_params.merge(loser: nil))).to_not be_valid
      expect(MatchValidator.new(valid_params.merge(loser: ''))).to_not be_valid
    end

    it 'must have different winner and losers' do
      expect(MatchValidator.new(valid_params.merge(loser: 'sally'))).to_not be_valid
    end
  end
end
