module TournamentService
  extend self, BaseService

  delegate :tournament_rankings, to: DashboardService

  def create_missing_tournaments
    Match.all.each do |match|
      if find_for(match.created_at).nil?
        tournament = spanning(match.created_at)
        tournament.save
      end
    end
  end

  def find_tournaments_with_no_winners
    Tournament.all
  end

  def pick_winners
    find_tournaments_with_no_winners.each do |tournament|
      next if tournament.end_date > DateTime.now
      tournament_ranking = TournamentRanking.new(
        start_date: tournament.start_date,
        end_date: tournament.end_date)
      winner_standing = tournament_ranking.determine_rankings.first
      tournament.winner_key = winner_standing.key
      tournament.save!
    end
  end

  def find_for(match_date)
    tournament = spanning(match_date)
    Tournament.find_by_start_date(tournament.start_date)
  end

  def spanning(match_date)
    tournament = Tournament.new
    tournament.start_date = match_date.beginning_of_week
    tournament.end_date = match_date.end_of_week
    tournament
  end
end
