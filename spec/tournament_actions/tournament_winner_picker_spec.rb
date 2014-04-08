require 'spec_helper'

describe TournamentWinnerPicker do
  subject(:picker) { TournamentWinnerPicker.new }

  describe '#pick_winners' do
    context 'without tournaments' do
      let(:old_match_date) { DateTime.new(2014, 1, 15) }
      let(:new_match_date) { DateTime.new(2014, 2, 15) }
      let!(:old_match) { Match.create(
          winner_key: 'bob',
          loser_key: 'alice',
          created_at: old_match_date) }
      let!(:new_match) { Match.create(
          winner_key: 'alice',
          loser_key: 'bob',
          created_at: new_match_date) }

      it 'creates tournaments with the correct winners' do
        expect {
          picker.pick_winners
        }.to change(Tournament, :count).by(2)

        tournament_1 = Tournament.first
        expect(tournament_1.winner_key).to eq('bob')
        expect(tournament_1.start_time).to eq(old_match_date.beginning_of_week)
        expect(tournament_1.end_time).to eq(old_match_date.end_of_week)

        tournament_2 = Tournament.last
        expect(tournament_2.winner_key).to eq('alice')
        expect(tournament_2.start_time).to eq(new_match_date.beginning_of_week)
        expect(tournament_2.end_time).to eq(new_match_date.end_of_week)
      end
    end

    context 'with tournaments' do
    end
  end

end