class TournamentController < BaseController
  using_service TournamentService

  def show
    @standings = service.tournament_rankings
  end
end
