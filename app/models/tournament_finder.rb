class TournamentFinder

  def find_wins_for_player(winner_key)
    tournaments = Tournament.where(winner_key: winner_key)
    tournaments.map{|t| TournamentStruct.new(t.start_time, t.end_time, t.winner_key) }
  end

  def find_most_recent_tournament
    tournament = Tournament.order('end_time DESC').first
    raise NoTournamentFound.new unless tournament.present?
    TournamentStruct.new(tournament.start_time, tournament.end_time, tournament.winner_key)
  end

  class NoTournamentFound < StandardError; end
end