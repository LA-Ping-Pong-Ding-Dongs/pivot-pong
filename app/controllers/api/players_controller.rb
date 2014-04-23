class Api::PlayersController < BaseController
  using_service PlayerService

  api :GET, 'players.json'
  def index
    self.collection = service.get_all
    respond_to do |fmt|
      fmt.json do
        render json: {players: collection.as_json(only: [:name, :key, :mean]) }
      end
    end
  end
end
