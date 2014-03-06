class MatchFinder
  def find_all_for_player(player_key)
    Match.where('winner_key = ? OR loser_key = ?', player_key, player_key).order('created_at DESC').map(&:to_struct)
  end

  def find_recent_matches_for_player(player_key, limit)
    Match
    .select('matches.*, winners.name as winner_name, losers.name as loser_name')
    .where('winner_key = ? OR loser_key = ?', player_key, player_key)
    .joins('inner join players as winners on winners.key = matches.winner_key')
    .joins('inner join players as losers on losers.key = matches.loser_key')
    .order('created_at DESC')
    .limit(limit).map do |match|
      ReadOnlyStruct.new({
                         id: match.id,
                         created_at: match.created_at,
                         winner_name: match.winner_name,
                         loser_name: match.loser_name,
                         winner_key: match.winner_key,
                         loser_key: match.loser_key,
                     })
    end
  end

  def find_unprocessed_matches
    Match.where(processed: false).map(&:to_struct)
  end
end