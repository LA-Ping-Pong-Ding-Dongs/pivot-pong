class MatchCreator
  def create_match(winner_key: raise(ArgumentError), loser_key: raise(ArgumentError))
    match = Match.create(winner_key: winner_key, loser_key: loser_key)
    ReadOnlyStruct.new(winner_key: match.winner_key, loser_key: match.loser_key)
  end
end