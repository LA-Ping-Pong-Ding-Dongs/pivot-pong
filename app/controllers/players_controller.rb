class PlayersController < ApplicationController
  RECENT_MATCHES_LIMIT = 5

  def index
    @players = player_finder.find_all_players

    respond_to do |format|
      format.js do
        render json: players_json_presenter(@players).as_json
      end
      format.html
    end
  end

  def show
    player = player_finder.find(params[:key])
    matches = match_finder.find_all_for_player(player.key)
    recent_matches = match_finder.find_recent_matches_for_player(player.key, RECENT_MATCHES_LIMIT)
    tournament_wins = tournament_finder.find_wins_for_player(player.key)

    respond_to do |format|
      format.js do
        render json: { results: player_presenter(player, matches, recent_matches, tournament_wins).as_json }
      end
      format.html do
        @player_information = player_presenter(player, matches, recent_matches, tournament_wins)
      end
    end
  end

  def edit
    player = player_finder.find(params[:key])
    @player = player_presenter(player, nil, nil, nil)
  end

  def update
    if player_validator.valid?
      player_updater.update_for_player(params[:key], player_updater_params)
      redirect_to player_path(params[:key])
    else
      redirect_to edit_player_path(params[:key]), alert: player_validator.errors.full_messages
    end
  end

  private

  def player_validator_params
    params.require(:player).permit(:name).merge({key: params[:key]})
  end

  def player_updater_params
    params.require(:player).permit(:name)
  end

  def player_finder
    PlayerFinder.new
  end

  def player_updater
    @player_updater ||= new_player_updater
  end

  def new_player_updater
    PlayerUpdater.new
  end

  def player_validator
    @player_validator ||= new_player_validator
  end

  def new_player_validator
    PlayerValidator.new(player_validator_params)
  end

  def match_finder
    MatchFinder.new
  end

  def tournament_finder
    TournamentFinder.new
  end

  def player_presenter(player, matches, recent_matches, tournament_wins)
    PlayerPresenter.new(player, matches, recent_matches, tournament_wins)
  end

  def players_json_presenter(players)
    PlayersJsonPresenter.new(players)
  end
end
