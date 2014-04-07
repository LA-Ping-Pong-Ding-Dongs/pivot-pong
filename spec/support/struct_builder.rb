module StructBuilder
  def build_match_struct(match)
    MatchStruct.new(match.id, match.winner_key, match.loser_key, match.created_at)
  end

  def build_match_with_names_struct(match, winner_name, loser_name)
    MatchWithNamesStruct.new(match.id, match.winner_key, match.loser_key, winner_name, loser_name, match.created_at)
  end

  def build_player_struct(player)
    PlayerStruct.new(player.key, player.name, player.mean, player.sigma)
  end

  def build_tournament_struct(tournament)
    TournamentStruct.new(tournament.start_time, tournament.end_time, tournament.winner_key)
  end
end
