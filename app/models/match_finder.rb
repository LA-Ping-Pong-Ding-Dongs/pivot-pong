class MatchFinder
  def find_all_for_player(player_key)
    Match
    .where('winner_key = ? OR loser_key = ?', player_key, player_key)
    .order('created_at DESC')
    .map(&:to_struct)
  end

  def find_recent_matches_for_player(player_key, limit)
    match_with_player_names
    .where('winner_key = ? OR loser_key = ?', player_key, player_key)
    .order('created_at DESC')
    .limit(limit)
    .map { |match| match_and_player_struct(match) }
  end

  def find_unprocessed
    match_with_player_names
    .where(processed: false)
    .order('created_at DESC')
    .map { |match| match_and_player_struct(match) }
  end

  def find_all
    match_with_player_names
    .order('created_at DESC')
    .map { |match| match_and_player_struct(match) }
  end

  private

  def match_with_player_names
    Match
    .select('matches.*, winners.name as winner_name, losers.name as loser_name')
    .joins('inner join players as winners on winners.key = matches.winner_key')
    .joins('inner join players as losers on losers.key = matches.loser_key')
  end

  def match_and_player_struct(match)
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
