class NttrsParamBuilder

  def build_player_data(players)
    players.map do |player|
      if player.mean && player.sigma
        {id: player.key, law: {mean: player.mean, sigma: player.sigma}}
      else
        {id: player.key}
      end
    end
  end

  def build_match_data(matches)
    match_data = matches.map do |match|
      {
          time: match.created_at.to_i,
          winner_id: match.winner_key,
          loser_id: match.loser_key,
      }
    end

    { matches: match_data }
  end

end