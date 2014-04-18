class TournamentRanking
  attr_reader :start_date, :end_date

  def initialize(
    match_finder = MatchFinder.new,
    player_standings_builder = PlayerStandingsBuilder.new,
    start_date = Time.now.beginning_of_week,
    end_date = Time.now
  )
    @match_finder = match_finder
    @player_standings_builder = player_standings_builder
    @start_date = start_date
    @end_date = end_date
  end

  def determine_rankings
    matches = @match_finder.find_matches_for_tournament(@start_date, @end_date)
    @player_standings_builder.get_ordered_standings_for_matches(matches)
  end

end

