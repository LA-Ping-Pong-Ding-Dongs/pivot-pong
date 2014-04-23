module DashboardService
  extend self
  delegate :all, to: Player

  def new_match
    MatchFactory.new
  end

  def tournament_rankings
    Tournament.new.determine_rankings
  end
end
