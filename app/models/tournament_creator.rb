class TournamentCreator
  def create_tournament(start_time: raise(ArgumentError), end_time: raise(ArgumentError), winner_key: raise(ArgumentError))
    record = Tournament.create(start_time: start_time, end_time: end_time, winner_key: winner_key)
    TournamentStruct.new(record.start_time, record.end_time, record.winner_key)
  end
end