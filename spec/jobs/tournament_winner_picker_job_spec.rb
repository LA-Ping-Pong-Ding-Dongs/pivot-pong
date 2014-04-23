require 'spec_helper'

describe TournamentWinnerPickerJob do
  describe '.perform' do
    let(:tournament_service) { TournamentService }
    before do
      allow(TournamentService).to receive(:new).and_return(tournament_service)
    end

    it 'requests that any missing tournament be created' do
      expect(tournament_service).to receive(:create_missing_tournaments).with(no_args)
      described_class.perform
    end

    it 'requests that winners are picked for all tournaments that have no winner' do
      expect(tournament_service).to receive(:pick_winners).with(no_args)
      described_class.perform
    end
  end
end
