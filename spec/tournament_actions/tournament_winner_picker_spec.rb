require 'spec_helper'

describe TournamentWinnerPicker do
  subject(:picker) { TournamentWinnerPicker.new }

  describe '#pick_winners' do
    context 'there are no persisted tournaments' do
      let(:during_tournament_1) { DateTime.new(2014, 1, 15) }
      let(:during_tournament_2) { DateTime.new(2014, 2, 15) }
      let!(:old_match) { Match.create(
          winner_key: 'bob',
          loser_key: 'alice',
          created_at: during_tournament_1) }
      let!(:new_match) { Match.create(
          winner_key: 'alice',
          loser_key: 'bob',
          created_at: during_tournament_2) }

      it 'creates the right number of tournaments' do
        expect {
          picker.pick_winners
        }.to change(Tournament, :count).by(2)
      end

      it 'makes each tournament one week long' do
        tournament_1 = Tournament.first
        expect(tournament_1.start_time).to eq(during_tournament_1.beginning_of_week)
        expect(tournament_1.end_time).to eq(during_tournament_1.end_of_week)

        tournament_2 = Tournament.last
        expect(tournament_2.start_time).to eq(during_tournament_2.beginning_of_week)
        expect(tournament_2.end_time).to eq(during_tournament_2.end_of_week)
      end

      it 'picks the correct winners' do
        tournament_1 = Tournament.first
        expect(tournament_1.winner_key).to eq('bob')

        tournament_2 = Tournament.last
        expect(tournament_2.winner_key).to eq('alice')
      end
    end

    context 'there are persisted tournaments' do
    end
  end

end
