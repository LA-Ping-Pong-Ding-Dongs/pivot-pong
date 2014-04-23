class DashboardController < BaseController
  using_service DashboardService
  page_size 100

  def show
    @match = service.new_match
    @tournament_rankings = service.tournament_rankings
  end
end
