class TournamentFinder

  def find_wins_for_player(winner_key)
    tournaments = Tournament.where(winner_key: winner_key)
    tournaments.map{|t| TournamentStruct.new(t.start_time, t.end_time, t.winner_key) }
  end

end