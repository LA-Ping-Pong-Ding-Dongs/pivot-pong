class DashboardController < BaseController
  using_service DashboardService
  page_size 100

  def show
    set_collection
    @match = service.new_match
    @tournament_rankings = service.tournament_rankings
  end
end
