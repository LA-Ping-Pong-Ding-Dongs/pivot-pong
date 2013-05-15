require 'spec_helper'

describe DoublesMatchesController do
  describe '#index' do
    it 'shows a list of doubles matches' do
      create(:match)
      m1 = create(:doubles_match)
      m2 = create(:doubles_match)

      get :index
      expect(assigns[:matches]).to_not be_nil
      expect(assigns[:matches]).to match_array([m1, m2])

      response.body.should include("<td>#{m1.winner}</td>")
    end
  end

  describe 'GET rankings' do
    let(:team_1) { FactoryGirl.create(:team) }
    let(:team_2) { FactoryGirl.create(:team) }

    before do
      Match.create winner: team_1, loser: team_2
    end

    it 'list teams by point ranking' do
      get :rankings

      response.should be_success
      assigns(:rankings).should == [[team_1, 8]]
    end
  end
end
