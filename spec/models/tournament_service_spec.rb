require 'spec_helper'

describe TournamentService do
  describe '#find_for' do
    let(:match_date) { DateTime.new(2014, 04, 16) }
    let(:tournament) { TournamentService.spanning(match_date) }
    subject { TournamentService.find_for(match_date) }

    context 'when the Tournament exists' do
      before { tournament.save! }
      it 'returns the Tournament that includes the match date' do
        expect(subject).to eq tournament
      end
    end

    context 'when the Tournament does not exist' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

  end

  describe '#create_missing_tournaments' do
    context 'there is a match' do
      let(:some_match_date) { DateTime.new(2014, 03, 03, 17, 50, 16) }
      before do
        Match.create(created_at: some_match_date)
      end
      context 'there is no Tournament defined for that time span' do
        it 'creates a Tournament for that time span' do
          expect(TournamentService.find_for some_match_date).to be_nil
          TournamentService.create_missing_tournaments
          expect(TournamentService.find_for(some_match_date)).to_not be_nil
        end
      end
      context 'there is a Tournament already defined for that time span' do
        let(:tournament) { TournamentService.spanning(some_match_date) }
        before { tournament.save! }
        it 'does not create a new Tournament' do
          TournamentService.create_missing_tournaments
          expect(Tournament.where(start_date: tournament.start_date).count).to eq 1
        end
      end
    end
    context 'there are two matches, each in a different time span' do
      let(:first_match_date) { DateTime.new(2014, 01, 03, 17, 50, 16) }
      let(:second_match_date) { DateTime.new(2014, 03, 03, 17, 50, 16) }
      let(:first_tournament_start_date ) { TournamentService.spanning(first_match_date).start_date }
      let(:second_tournament_start_date ) { TournamentService.spanning(second_match_date).start_date }
      before do
        Match.create(created_at: first_match_date)
        Match.create(created_at: second_match_date)
      end
      it 'creates a Tournament for each time span' do
          TournamentService.create_missing_tournaments
          expect(Tournament.where(start_date: first_tournament_start_date).count).to eq 1
          expect(Tournament.where(start_date: second_tournament_start_date).count).to eq 1
          expect(Tournament.all.count).to eq 2
      end
    end
    context 'there are two matches, both in the same time span' do
      let(:first_match_date) { DateTime.new(2014, 03, 03, 17, 50, 16) }   # a Monday
      let(:second_match_date) { DateTime.new(2014, 03, 04, 17, 50, 16) }  # the following Tuesday
      let(:tournament_start_date ) { TournamentService.spanning(first_match_date).start_date }
      before do
        Match.create(created_at: first_match_date)
        Match.create(created_at: second_match_date)
      end
      it 'creates only one Tournament for the time span' do
          TournamentService.create_missing_tournaments
          expect(Tournament.where(start_date: tournament_start_date).count).to eq 1
          expect(Tournament.all.count).to eq 1
      end
    end
  end

  describe '.spanning' do
    let(:match_date) { DateTime.new(2014, 4, 16) }  # a Wednesday
    let(:the_monday_before) { DateTime.new(2014, 4, 14) }
    let(:the_sunday_after) { DateTime.new(2014, 4, 20, 23, 59, 59) }

    subject { TournamentService.spanning(match_date) }

    it 'returns a new Tournament instance which contains the match date' do
      expect(subject.start_date).to_not be_nil
      expect(subject.start_date).to be < match_date
      expect(subject.end_date).to_not be_nil
      expect(subject.end_date).to be > match_date
    end
    it 'starts on the Monday of the same week' do
      expect(subject.start_date).to eq the_monday_before
    end
    it 'ends on the Sunday of the same week' do
      expect(subject.end_date).to eq the_sunday_after
    end
  end

  describe '#pick_winners' do
    before { Timecop.freeze(now.to_time) }
    after { Timecop.return }

    let(:winner) { Player.create(key: '70ec1678-35f0-4bf0-b09d-9207f7f5d1b8', name: 'Wallace') }
    let(:loser) { Player.create(key: '2f8ff742-4c56-4d06-9b57-dc90e0c0f949', name: 'Laurence') }
    let(:tournament) { TournamentService.spanning(DateTime.new(2014, 4, 22)) }
    let(:match_date) { tournament.start_date.advance(hours: 1) }

    before do
      Match.create(winner_key: winner.key, loser_key: loser.key, created_at: match_date)
      tournament.save!
    end

    context 'when the tournament is over' do
      let(:now) { tournament.end_date.since(1) }

      it 'picks a winner for the tournament' do
        TournamentService.pick_winners
        expect(Tournament.find_by_start_date(tournament.start_date).winner_key).to eq winner.key
      end
    end

    context 'when the tournament is ongoing' do
      let(:now) { tournament.end_date.ago(1) }

      it 'does not pick a winner for the tournament' do
        TournamentService.pick_winners
        expect(Tournament.find_by_start_date(tournament.start_date).winner_key).to be_nil
      end
    end
  end
end
