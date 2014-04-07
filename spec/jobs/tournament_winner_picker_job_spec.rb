require 'spec_helper'

describe TournamentWinnerPickerJob do
  describe '.perform' do
    it 'calls the winner picker' do
      expect(TournamentWinnerPicker).to receive(:pick_winners).with(no_args)

      described_class.perform
    end
  end
end