class DashboardController < BaseController
  using_service Player

  def show
    @match = MatchService.new
    @tournament_rankings = Tournament.new.determine_rankings
  end
end
