require 'spec_helper'

describe TournamentService do
  describe '#create_missing_tournaments' do
    context 'when there already exists a tournament for every week' do
      let(:date_of_first_match_ever) { DateTime.now.weeks_ago(12) }

      it 'there will be a tournament for every week' do
   #    first_tournament = Tournament.new(date_of_first_match_ever)
   #    total_number_of_weeks = first_tournament.weeks_ago
      end
    end

    context 'when there is one missing tournament' do
      it 'there will be a tournament for every week'
    end

    context 'when there is more than one missing tournament' do
      it 'there will be a tournament for every week'
    end

    describe '#pick_winners' do
    end
  end
end
