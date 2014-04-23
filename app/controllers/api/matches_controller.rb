class Api::MatchesController < BaseController
  using_service MatchService

  api :GET, 'matches.json'
  def index
    super
  end

  api :POST, 'matches.json'
  def create
    super
  end

  def safe_params
    params.require(:match).permit(:winner, :loser)
  end
end
