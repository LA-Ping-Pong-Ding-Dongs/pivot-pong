class TournamentService

  def self.create_missing_tournaments
    Match.all.each do |match|
      if self.find_for(match.created_at).nil?
        tournament = spanning(match.created_at)
        tournament.save
      end
    end
  end

  def self.pick_winners

  end

  def self.find_for(match_date)
    tournament = spanning(match_date)
    Tournament.find_by_start_date(tournament.start_date)
  end

  def self.spanning(match_date)
    tournament = Tournament.new
    tournament.start_date = match_date.beginning_of_week
    tournament.end_date = match_date.end_of_week
    tournament
  end

end
