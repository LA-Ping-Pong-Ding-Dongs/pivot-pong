  class TournamentWinnerPickerJob
    def self.queue; :normal; end
    def self.perform
      TournamentWinnerPicker.pick_winners
    end
  end