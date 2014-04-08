require 'spec_helper'

describe PlayerStanding do

  subject(:standing) { PlayerStanding.new('abfa9dba916f2e487d64ccdb658ce6d0', 'Bob') }
  let(:sally) { {key: '99ce27141314607c8d0d3cec9807c67f'} }
  let(:templeton) { {key: '544151cd41aaa51edfd4a0bd2ccbef03'} }

  it 'sets defaults upon initialization' do
    expect(standing.name).to eq 'Bob'
    expect(standing.key).to eq 'abfa9dba916f2e487d64ccdb658ce6d0'
    expect(standing.wins).to eq 0
    expect(standing.losses).to eq 0
    expect(standing.most_recent_win).to eq Time.new(0)
    expect(standing.most_recent_match).to eq Time.new(0)
  end

  describe '#add_to_wins' do
    it 'incraments wins by 1' do
      expect(standing.wins).to eq 0
      subject.add_to_wins

      expect(standing.wins).to eq 1
    end
  end

  describe '#add_to_losses' do
    it 'incraments losses by 1' do
      expect(standing.losses).to eq 0
      subject.add_to_losses

      expect(standing.losses).to eq 1
    end
  end

  describe 'opponent counting' do
    it 'returns 0 unique opponents when no games played' do
      expect(subject.unique_opponents_count).to eq 0
    end

    it 'Adds an opponent for the player' do
      subject.add_opponent(sally[:key])

      expect(subject.unique_opponents_count).to eq 1
    end

    it 'does not count the same opponent twice' do
      subject.add_opponent(sally[:key])
      subject.add_opponent(sally[:key])

      expect(subject.unique_opponents_count).to eq 1
    end

    it 'allows adding multiple opponents' do
      subject.add_opponent(sally[:key])
      subject.add_opponent(templeton[:key])

      expect(subject.unique_opponents_count).to eq 2
    end
  end

  describe '#store_most_recent_win' do
    it 'sets most_recent_win if greater than current most_recent_win' do
      time = Time.now

      subject.store_most_recent_win(3.minutes.ago)
      subject.store_most_recent_win(time)

      expect(subject.most_recent_win).to eq time
    end

    it 'keeps current most_recent_win if value is less than most_recent_win' do
      time = Time.now

      subject.store_most_recent_win(time)
      subject.store_most_recent_win(3.minutes.ago)

      expect(subject.most_recent_win).to eq time
    end

    it 'sets most_recent_win to value if most_recent_win is nil' do
      time = Time.now
      subject.store_most_recent_win(time)

      expect(subject.most_recent_win).to eq time
    end
  end

  describe '#store_most_recent_match' do
    it 'sets most_recent_match if greater than current most_recent_match' do
      time = Time.now

      subject.store_most_recent_match(3.minutes.ago)
      subject.store_most_recent_match(time)

      expect(subject.most_recent_match).to eq time
    end

    it 'keeps current most_recent_match if value is less than most_recent_match' do
      time = Time.now

      subject.store_most_recent_match(time)
      subject.store_most_recent_match(3.minutes.ago)

      expect(subject.most_recent_match).to eq time
    end

    it 'sets most_recent_match to value if most_recent_match is nil' do
      time = Time.now
      subject.store_most_recent_match(time)

      expect(subject.most_recent_match).to eq time
    end
  end

  describe '#standings_score' do
    it 'returns winning percentage multiplied by unique opponents count' do
      subject.add_to_wins
      subject.add_to_wins
      subject.add_to_losses
      subject.add_opponent(sally[:key])
      subject.add_opponent(sally[:key])
      subject.add_opponent(templeton[:key])

      expect(subject.standings_score).to eq (2.0 / 3 * 2)
    end
  end
end
