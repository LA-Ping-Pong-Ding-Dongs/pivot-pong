require 'spec_helper'

describe PlayerStandingsBuilder do

  let(:match_1) { MatchWithNamesStruct.new(1, 'rocky', 'bullwinkle', 'Rocky', 'Bullwinkle', 20.minutes.ago) }
  let(:match_2) { MatchWithNamesStruct.new(2, 'boris', 'bullwinkle', 'Boris', 'Bullwinkle', 19.minutes.ago) }
  let(:match_3) { MatchWithNamesStruct.new(3, 'boris', 'rocky', 'Boris', 'Rocky', 18.minutes.ago) }
  let(:match_4) { MatchWithNamesStruct.new(4, 'bullwinkle', 'boris', 'Bullwinkle', 'Boris', 17.minutes.ago) }
  let(:match_5) { MatchWithNamesStruct.new(5, 'rocky', 'bullwinkle', 'Rocky', 'Bullwinkle', 16.minutes.ago) }
  let(:match_6) { MatchWithNamesStruct.new(6, 'natasha', 'cpt', 'Natasha', 'Captain Peter "Wrongway" Peachfuzz', 15.minutes.ago) }
  let(:match_7) { MatchWithNamesStruct.new(7, 'natasha', 'cpt', 'Natasha', 'Captain Peter "Wrongway" Peachfuzz', 14.minutes.ago) }
  let(:match_8) { MatchWithNamesStruct.new(8, 'natasha', 'cpt', 'Natasha', 'Captain Peter "Wrongway" Peachfuzz', 13.minutes.ago) }
  let(:match_9) { MatchWithNamesStruct.new(9, 'cpt', 'natasha', 'Captain Peter "Wrongway" Peachfuzz', 'Natasha', 12.minutes.ago) }
  let(:match_10) { MatchWithNamesStruct.new(10, 'mrbig', 'fearless', 'Mr. Big', 'Fearless Leader', 11.minutes.ago) }
  let(:match_11) { MatchWithNamesStruct.new(11, 'mrbig', 'cloyd', 'Mr. Big', 'Cloyd', 10.minutes.ago) }

  let(:matches) { [match_11, match_10, match_9, match_8, match_7, match_6, match_5, match_4, match_3, match_2, match_1] }

  subject { PlayerStandingsBuilder.new }

  describe '#get_ordered_standings_for_matches' do
    it 'returns an empty array if there are no matches' do
      expect(subject.get_ordered_standings_for_matches([])).to eq []
    end

    it 'returns a list of player standing objects with best player first' do
      rankings = subject.get_ordered_standings_for_matches(matches)

      expect(rankings[0].key).to eq('mrbig')
      expect(rankings[0].name).to eq('Mr. Big')
      expect(rankings[0].wins).to eq(2)
      expect(rankings[0].losses).to eq(0)
      expect(rankings[0].unique_opponents_count).to eq(2)

      expect(rankings[1].key).to eq('rocky')
      expect(rankings[1].name).to eq('Rocky')
      expect(rankings[1].wins).to eq(2)
      expect(rankings[1].losses).to eq(1)
      expect(rankings[1].unique_opponents_count).to eq(2)

      expect(rankings[2].key).to eq('boris')
      expect(rankings[2].name).to eq('Boris')
      expect(rankings[2].wins).to eq(2)
      expect(rankings[2].losses).to eq(1)
      expect(rankings[2].unique_opponents_count).to eq(2)

      expect(rankings[3].key).to eq('natasha')
      expect(rankings[3].name).to eq('Natasha')
      expect(rankings[3].wins).to eq(3)
      expect(rankings[3].losses).to eq(1)
      expect(rankings[3].unique_opponents_count).to eq(1)

      expect(rankings[4].key).to eq('bullwinkle')
      expect(rankings[4].name).to eq('Bullwinkle')
      expect(rankings[4].wins).to eq(1)
      expect(rankings[4].losses).to eq(3)
      expect(rankings[4].unique_opponents_count).to eq(2)

      expect(rankings[5].key).to eq('cpt')
      expect(rankings[5].name).to eq('Captain Peter "Wrongway" Peachfuzz')
      expect(rankings[5].wins).to eq(1)
      expect(rankings[5].losses).to eq(3)
      expect(rankings[5].unique_opponents_count).to eq(1)

      expect(rankings[6].key).to eq('cloyd')
      expect(rankings[6].name).to eq('Cloyd')
      expect(rankings[6].wins).to eq(0)
      expect(rankings[6].losses).to eq(1)
      expect(rankings[6].unique_opponents_count).to eq(1)

      expect(rankings[7].key).to eq('fearless')
      expect(rankings[7].name).to eq('Fearless Leader')
      expect(rankings[7].wins).to eq(0)
      expect(rankings[7].losses).to eq(1)
      expect(rankings[7].unique_opponents_count).to eq(1)
    end

    it 'returns the top elements if no range parameter is provided' do
      Kernel.silence_warnings do
        @player_limit = described_class::PLAYER_STANDINGS_LIMIT
        described_class::PLAYER_STANDINGS_LIMIT = 2
      end

      expect(subject.get_ordered_standings_for_matches([match_1, match_2, match_3]).length).to be 2

      Kernel.silence_warnings do
        described_class::PLAYER_STANDINGS_LIMIT = @player_limit
      end
    end

    it 'returns the top elements if range parameter is provided' do
      expect(subject.get_ordered_standings_for_matches([match_1, match_2], limit: 1).length).to be 1
    end
  end

end
