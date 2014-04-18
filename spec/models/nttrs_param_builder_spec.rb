require 'spec_helper'

describe NttrsParamBuilder do
  subject { NttrsParamBuilder.new }

  shared_context "players" do
    let(:bob) { PlayerStruct.new('544151cd41aaa51edfd4a0bd2ccbef03', 'Bob', 2300, 23) }
    let(:sally) { PlayerStruct.new('9621b65bf7c398ee7fd4a708a8171a54', 'Sally', 1850, 40) }
    let(:templeton) { PlayerStruct.new('abfa9dba916f2e487d64ccdb658ce6d0', 'Templeton', nil, nil) }
  end

  describe '#build_player_data' do
    include_context "players"

    it 'returns data in the format the Nttrs gem expects' do
      expected_params = [
          {id: templeton.key, law: {mean: 1400, sigma: 450}},
          {id: sally.key, law: {mean: 1850, sigma: 40}},
          {id: bob.key, law: {mean: 2300, sigma: 23}},
      ]

      expect(subject.build_player_data([bob, sally, templeton])).to match_array(expected_params)
    end
  end

  describe '#build_match_data' do
    include_context "players"

    let(:match_1_time) { Time.new(2012, 12, 12) }
    let(:match_1) { Match.new(winner_key: bob.key, loser_key: sally.key, created_at: match_1_time) }

    let(:match_2_time) { Time.new(2012, 1, 1) }
    let(:match_2) { Match.new(winner_key: sally.key, loser_key: templeton.key, created_at: match_2_time) }

    it 'returns data in the format the Nttrs gem expects' do
      expected_params = {
          matches: [
              { time: match_1_time.to_i, winner_id: bob.key, loser_id: sally.key },
              { time: match_2_time.to_i, winner_id: sally.key, loser_id: templeton.key },
          ]
      }

      expect(subject.build_match_data([match_1, match_2])).to eq expected_params
    end
  end
end
