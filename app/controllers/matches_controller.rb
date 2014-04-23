class MatchesController < BaseController
  using_service MatchService
  decorate_with MatchDecorator

  def recent
    set_collection(service.find_recent)
    index
  end

  private

  def safe_params
    params.require(:match).permit(:winner, :loser)
  end
end
