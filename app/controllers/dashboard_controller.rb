class DashboardController < ApplicationController

  def show
    @match = MatchForm.new({})
    @players = new_player_finder.find_all_players
    @tournament_rankings = tournament_ranking.determine_rankings
  end

  private

  def new_player_finder
    PlayerFinder.new
  end

  def tournament_ranking
    TournamentRanking.new
  end
end
