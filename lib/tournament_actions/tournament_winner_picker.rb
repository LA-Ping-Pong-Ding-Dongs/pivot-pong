class TournamentWinnerPicker
  attr_accessor :tournament

  def initialize
    @tournament_finder = TournamentFinder.new
    @match_finder = MatchFinder.new
  end

  def pick_winners
    until latest_tournament_available?
      match = get_oldest_match_without_tournament
      start_time, end_time = calculate_time_period(match)
      winner = determine_winner
      TournamentCreator(start_time: start_time, end_time: end_time, winner: winner)
    end
  end

  def calculate_time_period(match)
    start_time = match.created_at.beginning_of_week
    end_time = match.created_at.end_of_week
    return [start_time, end_time]
  end

  def get_old_match_without_tournament
  end

  def latest_tournament_available?
    tournament = @tournament_finder.find_most_recent_tournament rescue nil
    return tournament
  end

  def determine_winner
  end
end