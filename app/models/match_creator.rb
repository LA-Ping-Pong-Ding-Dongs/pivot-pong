class MatchCreator
  def create_match(winner_key: raise(ArgumentError), loser_key: raise(ArgumentError))
    match = Match.create(winner_key: winner_key, loser_key: loser_key)
    MatchStruct.new(match.id, match.winner_key,  match.loser_key, match.created_at)
  end
end