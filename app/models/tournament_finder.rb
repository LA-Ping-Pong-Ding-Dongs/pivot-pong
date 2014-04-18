class TournamentFinder

  def find_wins_for_player(winner_key)
    tournaments = TournamentRecord.where(winner_key: winner_key)
    tournaments.map{|t| Tournament.new(t.start_date, t.end_date, t.winner_key) }
  end

  def find_most_recent_tournament
    tournament = TournamentRecord.order('end_date DESC').first
    raise NoTournamentFound.new unless tournament.present?
    Tournament.new(tournament.start_date, tournament.end_date, tournament.winner_key)
  end

  class NoTournamentFound < StandardError; end
end
