  class TournamentWinnerPickerJob
    def self.queue; :normal; end
    def self.perform
      TournamentWinnerPicker.new.pick_winners
    end
  end