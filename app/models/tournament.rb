class Tournament
  attr_reader :start_time, :end_time

  def initialize(
    match_finder = MatchFinder.new,
    player_standings_builder = PlayerStandingsBuilder.new,
    start_time = Time.now.beginning_of_week,
    end_time = Time.now
  )
    @match_finder = match_finder
    @player_standings_builder = player_standings_builder
    @start_time = start_time
    @end_time = end_time
  end

  def determine_rankings
    matches = @match_finder.find_matches_for_tournament(@start_time, @end_time)
    @player_standings_builder.get_ordered_standings_for_matches(matches)
  end

end

