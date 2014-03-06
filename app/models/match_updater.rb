class MatchUpdater

  def mark_as_processed(match_id)
    match = Match.find(match_id)
    match.update_attributes!(processed: true)
  end

end