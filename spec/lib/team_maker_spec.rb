require 'spec_helper'

describe TeamMaker do
  describe '.team_from' do
    let(:player1) { create :player }
    let(:player2) { create :player }
    let(:player3) { create :player }
    let!(:team_with_name) { create(:team, name: 'already here') }
    let!(:team_with_name_and_players) { create(:team, name: 'players', player1: player1, player2: player2) }
    let!(:team_with_players) { create(:team, player1: player1, player2: player3) }

    it 'returns a Team with the passed in name' do
      team = TeamMaker.team_from({ name: 'coffee lovers' })
      expect(team).to be_an_instance_of(Team)
      expect(team.name).to eq('coffee lovers')
    end

    it 'does not make a duplicate team' do
      team = TeamMaker.team_from(name: 'already here')
      expect(team).to eq(team_with_name)
      expect(team).to_not be_new_record

      other_team = TeamMaker.team_from(name: 'players')
      expect(other_team).to eq(team_with_name_and_players)
      expect(other_team).to_not be_new_record
    end

    it 'returns a Team from the existing passed in players' do
      team = TeamMaker.team_from(player1: { name: player1.name }, player2: { name: player3.name })
      expect(team).to eq(team_with_players)
    end

    it 'updates a team name when a new name is passed in for a team' do
      team = TeamMaker.team_from(name: 'new name', player1: { name: player1.name }, player2: { name: player2.name })
      expect(team).to eq(team_with_name_and_players)
      expect(team.name).to eq('new name')
    end

    it 'returns a new Team from pseudo existing players' do
      team = TeamMaker.team_from(player1: { name: 'danny boy' }, player2: { name: player2.name })
      expect(team).to be_new_record
      expect(team.player1.name).to eq('danny boy')
      expect(team.player2.name).to eq(player2.name)
    end
  end
end
