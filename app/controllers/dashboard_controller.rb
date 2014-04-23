class DashboardController < BaseController
  using_service Player
  page_size 100

  def show
    @match = MatchService.new
    @tournament_rankings = Tournament.new.determine_rankings
  end
end
