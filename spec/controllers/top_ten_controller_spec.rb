require 'spec_helper'

describe TopTenController do

  describe 'show' do
    it 'is successful' do
      get :show

      expect(response).to be_success
    end

    it 'lists the first ten singles and first ten doubles' do
      player_5 = create :player
      player_4 = create :player
      player_3 = create :player
      player_2 = create :player
      player_1 = create :player

      team_1 = create :team, player1: player_1, player2: player_2
      team_2 = create :team, player1: player_1, player2: player_3
      team_3 = create :team, player1: player_2, player2: player_3
      team_4 = create :team, player1: player_3, player2: player_4
      team_5 = create :team, player1: player_4, player2: player_5

      create :match, winner: player_1 , loser: player_2
      create :match, winner: player_1 , loser: player_3
      create :match, winner: player_1 , loser: player_4
      create :match, winner: player_1 , loser: player_5
      create :match, winner: player_2 , loser: player_3
      create :match, winner: player_2 , loser: player_4
      create :match, winner: player_2 , loser: player_5
      create :match, winner: player_3 , loser: player_4
      create :match, winner: player_3 , loser: player_5
      create :match, winner: player_4 , loser: player_5

      create :match, winner: team_1, loser: team_2
      create :match, winner: team_1, loser: team_3
      create :match, winner: team_1, loser: team_4
      create :match, winner: team_1, loser: team_5
      create :match, winner: team_2, loser: team_3
      create :match, winner: team_2, loser: team_4
      create :match, winner: team_2, loser: team_5
      create :match, winner: team_3, loser: team_4
      create :match, winner: team_3, loser: team_5
      create :match, winner: team_4, loser: team_5

      get :show

      expect(assigns[:singles]).to eq([[player_1, 30], [player_2, 23], [player_3, 16], [player_4, 8]])
      expect(assigns[:doubles]).to eq([[team_1, 30], [team_2, 23], [team_3, 16], [team_4, 8]])
    end
  end

end

