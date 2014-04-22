class Api::PlayersController < Api::BaseController

  api :GET, 'players.json'
  def index
    respond_with players: PlayersJsonPresenter.new(collection)
  end

  def player_finder
    PlayerFinder.new
  end

  def collection
    player_finder.find_all_players
  end
end
