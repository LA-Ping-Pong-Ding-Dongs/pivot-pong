class PlayersSearchController < ApplicationController
  def index
    players = player_finder.find_players_by_substring(params[:search])

    respond_to do |format|
      format.js do
        render json: players_json_presenter(players).as_json
      end
    end
  end

  private

  def player_finder
    PlayerFinder.new
  end

  def players_json_presenter(players)
    PlayersJsonPresenter.new(players)
  end
end