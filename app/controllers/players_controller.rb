class PlayersController < ApplicationController
  RECENT_MATCHES_LIMIT = 5

  def index
    players = player_finder.find_all_players

    respond_to do |format|
      format.js do
        render json: players_json_presenter(players).as_json
      end
    end
  end

  def show
    player = player_finder.find(params[:key])
    matches = match_finder.find_all_for_player(player.key)
    recent_matches = match_finder.find_recent_matches_for_player(player.key, RECENT_MATCHES_LIMIT)

    respond_to do |format|
      format.js do
        render json: { results: player_presenter(player, matches, recent_matches).as_json }
      end
      format.html do
        @player_information = player_presenter(player, matches, recent_matches)
      end
    end
  end

  private

  def player_finder
    PlayerFinder.new
  end

  def match_finder
    MatchFinder.new
  end

  def player_presenter(player, matches, recent_matches)
    PlayerPresenter.new(player, matches, recent_matches)
  end

  def players_json_presenter(players)
    PlayersJsonPresenter.new(players)
  end
end
