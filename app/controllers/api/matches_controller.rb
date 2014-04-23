class Api::MatchesController < Api::BaseController
  using_service MatchService

  def safe_params
    params.require(:match).permit(:winner, :loser)
  end
end
