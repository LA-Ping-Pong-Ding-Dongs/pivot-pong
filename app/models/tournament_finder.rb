class TournamentFinder

  def find_wins_for_player(winner_key)
    Tournament.where(winner_key: winner_key)
  end

  def find_most_recent_tournament
    tournament = Tournament.order('end_date DESC').first
    raise NoTournamentFound.new unless tournament.present?
    tournament
  end

  class NoTournamentFound < StandardError; end
end
