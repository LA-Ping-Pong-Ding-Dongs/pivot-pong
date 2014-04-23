class TournamentCreator
  def create_tournament(start_date:, end_date:, winner_key:)
    Tournament.create(start_date: start_date, end_date: end_date, winner_key: winner_key)
  end
end
