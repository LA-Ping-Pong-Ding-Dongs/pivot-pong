require 'spec_helper'

describe DoublesMatchesController do
  describe '#index' do
    it 'shows a list of doubles matches' do
      create(:match)
      m1 = create(:doubles_match)
      m2 = create(:doubles_match)

      get :index
      expect(assigns[:matches]).to_not be_nil
      expect(assigns[:matches]).to match_array([m1,m2])

      response.body.should include("<td>#{m1.winner}</td>")
    end
  end
end
