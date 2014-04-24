require 'spec_helper'

describe TournamentRanking do

  let(:match_finder_double) { double(MatchFinder, find_matches_for_tournament: 'stub') }
  let(:player_standings_builder_double) { double(PlayerStandingsBuilder, get_ordered_standings_for_matches: true)}

  subject(:tournament_ranking) { TournamentRanking.new(match_finder: match_finder_double, player_standings_builder: player_standings_builder_double) }

  describe '#determine_rankings' do
    it 'returns player standing objects for matches within tournament time frame' do
      rankings = tournament_ranking.determine_rankings

      expect(match_finder_double).to have_received(:find_matches_for_tournament)
      expect(player_standings_builder_double).to have_received(:get_ordered_standings_for_matches).with('stub')
    end
  end
end

