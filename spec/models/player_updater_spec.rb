require 'spec_helper'

describe PlayerUpdater do
  let(:player) { Player.create key: '93fb9466661fe0da4f07df6a745ffb81', sigma: 40 }

  subject(:updater) { PlayerUpdater.new }

  describe '#update_for_player' do
    it 'updates the record with sigma and mean' do
      subject.update_for_player(player.key, sigma: 50)

      expect(player.reload.sigma).to eq(50)
    end

    it 'returns true when successful' do
      expect(subject.update_for_player(player.key, sigma: 50)).to eq true
    end
  end
end