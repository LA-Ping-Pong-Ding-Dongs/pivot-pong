class DashboardController < ApplicationController

  def show
    @match = MatchForm.new({})
    @players = new_player_finder.find_all_players
  end

  private

  def new_player_finder
    PlayerFinder.new
  end
end