class Api::PlayersController < BaseController
  using_service PlayerService

  api :GET, 'players.json'
  def index
    self.collection = service.get_all
  end
end
