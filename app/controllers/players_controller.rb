class PlayersController < ApplicationController
  def show
    player = player_finder.find(params[:key])
    matches = match_finder.find_all_for_player(player.key)

    @player_information = PlayerPresenter.new(player, matches)
  end

  private

  def player_finder
    PlayerFinder.new
  end

  def match_finder
    MatchFinder.new
  end
end