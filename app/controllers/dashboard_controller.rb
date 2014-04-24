class DashboardController < BaseController
  using_service DashboardService

  def show
    self.collection = service.get_all
    @match = service.new_match
    @tournament_rankings = service.tournament_rankings
  end
end
