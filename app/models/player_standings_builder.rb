class PlayerStandingsBuilder

  PLAYER_STANDINGS_LIMIT = 10

  def get_ordered_standings_for_matches(matches, limit: PLAYER_STANDINGS_LIMIT)
    standings = build_for_matches(matches)
    sort_standings(standings)[(0...limit)]
  end

  private

  def build_for_matches(matches)
    {}.tap do |player_standings|

      matches.each do |match|
        winner = match.winner_key
        loser = match.loser_key
        match_time = match.created_at

        unless player_standings[winner]
          player_standings[winner] = PlayerStanding.new(winner, match.winner_name)
        end
        tally_winner_stats(player_standings[winner], match_time, loser)

        unless player_standings[loser]
          player_standings[loser] = PlayerStanding.new(loser, match.loser_name)
        end
        tally_loser_stats(player_standings[loser], match_time, winner)
      end

    end.values
  end

  def sort_standings(standings)
    standings.sort! do |x, y|
      # first compare by score
      # if equal scores, fall back to unique opponents count
      # if equal unique opponents count, fall back to most recent win
      # if still tied, fall back to most recent match

      comparison = y.standings_score <=> x.standings_score
      comparison = comparison == 0 ? y.unique_opponents_count <=> x.unique_opponents_count : comparison
      comparison = comparison == 0 ? y.most_recent_win <=> x.most_recent_win : comparison
      comparison == 0 ? y.most_recent_match <=> x.most_recent_match : comparison
    end
  end

  def tally_winner_stats(winner_standing, match_time, loser)
    winner_standing.add_to_wins
    winner_standing.store_most_recent_win(match_time)
    winner_standing.store_most_recent_match(match_time)
    winner_standing.add_opponent(loser)
  end

  def tally_loser_stats(loser_standing, match_time, winner)
    loser_standing.add_to_losses
    loser_standing.store_most_recent_match(match_time)
    loser_standing.add_opponent(winner)
  end
end
