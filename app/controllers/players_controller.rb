class PlayersController < ApplicationController
  RECENT_MATCHES_LIMIT = 5

  def show
    @player = player_finder.find(params[:key])
    @matches = match_finder.find_all_for_player(@player.key)
    recent_matches = match_finder.find_recent_matches_for_player(@player.key, RECENT_MATCHES_LIMIT)

    respond_to do |format|
      format.js do
        render json: { results: player_info_json_presenter.as_json }
      end
      format.html do
        @player_information = PlayerPresenter.new(@player, @matches, recent_matches)
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

  def player_info_json_presenter
    PlayerInfoJsonPresenter.new(@player, @matches)
  end
end
