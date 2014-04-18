class TournamentCreator
  def create_tournament(start_date:, end_date:, winner_key:)
    record = TournamentRecord.create(start_date: start_date, end_date: end_date, winner_key: winner_key)
    Tournament.new(record.start_date, record.end_date, record.winner_key)
  end
end
