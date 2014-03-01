require 'spec_helper'

describe 'Player page', :js do
  let!(:bob) { Player.create(name: 'Bob', key: 'bob') }
  let!(:loser) { Player.create(name: 'Loser', key: 'loser') }
  let!(:champ) { Player.create(name: 'Champ', key: 'champ') }

  let(:april_1) { DateTime.new(2013, 04, 01) }
  let(:april_3) { DateTime.new(2013, 04, 03) }
  let(:april_4) { DateTime.new(2013, 04, 04) }

  let!(:winning_match_1) { Match.create(winner_key: bob.key, loser_key: loser.key, created_at: april_1) }
  let!(:winning_match_2) { Match.create(winner_key: bob.key, loser_key: loser.key, created_at: april_3) }
  let!(:losing_match) { Match.create(winner_key: champ.key, loser_key: bob.key, created_at: april_4) }

  it 'user can visit a player page' do
    visit player_path(bob)

    expect(page).to have_content 'Bob'
    within '.record' do
      expect(page).to have_content '2-1'
      expect(page).to have_content '66.7%'
    end

    within '.recent-matches' do
      expect(page).to have_content 'Beat Loser on 04/01/2013'
      expect(page).to have_content 'Beat Loser on 04/03/2013'
      expect(page).to have_content 'Lost to Champ on 04/04/2013'
    end
  end

end