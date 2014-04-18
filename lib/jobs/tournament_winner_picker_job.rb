class TournamentWinnerPickerJob
  def self.queue; :normal; end
  def self.perform
    tournament_service = TournamentService.new
    tournament_service.create_missing_tournaments
    tournament_service.pick_winners
  end
end
