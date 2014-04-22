class MatchesController < BaseController
  using_service MatchService
  decorate_with MatchDecorator

  def recent
    service.find_recent
  end

  private

  def safe_params
    params.require(:match).permit(:winner, :loser)
  end
end
