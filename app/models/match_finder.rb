class MatchFinder
  def find_all_for_player(player_key)
    Match
    .where('winner_key = ? OR loser_key = ?', player_key, player_key)
    .order('created_at DESC')
    .map{ |match| MatchStruct.new match.id, match.winner_key, match.loser_key, match.created_at }
  end

  def find_recent_matches_for_player(player_key, limit)
    match_with_player_names
    .where('winner_key = ? OR loser_key = ?', player_key, player_key)
    .order('created_at DESC')
    .limit(limit)
    .map { |record| match_and_player_struct(record) }
  end

  def find_matches_for_tournament(start_time, end_time, limit = nil)
    query = match_with_player_names
    .where('matches.created_at > ? AND matches.created_at <= ?', start_time, end_time)
    .order('matches.created_at DESC')
    query = query.limit(limit) if limit
    query.map { |record| match_and_player_struct(record) }
  end

  def find_all
    match_with_player_names
    .order('created_at DESC')
    .map { |record| match_and_player_struct(record) }
  end

  def find_page_of_matches(page_number, page_size)
    page = match_with_player_names
    .order('created_at DESC')
    .page(page_number)
    .per(page_size)
    matches = page.map { |record| match_and_player_struct(record) }
    { page: page, matches: matches }
  end

  private

  def match_with_player_names
    Match
    .select('matches.*, winners.name as winner_name, losers.name as loser_name')
    .joins('inner join players as winners on winners.key = matches.winner_key')
    .joins('inner join players as losers on losers.key = matches.loser_key')
  end

  def match_and_player_struct(record)
    MatchWithNamesStruct.new(record.id, record.winner_key, record.loser_key, record.winner_name, record.loser_name, record.created_at)
  end
end
