require 'spec_helper'

describe Match do
  describe "associations" do
    context "belongs_to" do
      [:winner, :loser].each do |association|
        it "should belong_to #{association}, class_name: 'Opponent'" do
          reflection = Match.reflect_on_association(association)
          reflection.macro.should == :belongs_to
          reflection.class_name.should == Opponent.name
        end
      end
    end
  end

  describe "validations" do
    let(:match) { Match.new }

    before { match.valid? }

    it "should not be valid" do
      match.errors.should include :winner, :loser
    end
  end

  describe "callbacks" do
    context "on create" do
      subject { Match.create }
      let(:occured_at) { Time.parse("2011-03-27") }
      before { Time.stub(:now).and_return(occured_at) }
      its(:occured_at) { should == occured_at }
    end
  end

  describe '.doubles_matches' do
    it 'returns only doubles matches' do
      create(:match)
      m1 = create(:doubles_match)
      m2 = create(:doubles_match)
      matches = Match.doubles_matches
      expect(matches).to_not be_nil
      expect(matches).to match_array([m1,m2])
    end
  end
end
