require 'spec_helper'

feature 'On the Tournament Leaderboard' do
  let(:bob) { Player.create(name: 'Bob', key: 'bob', mean: 1200, sigma: 140) }
  let(:bella) { Player.create(name: 'Bella', key: 'bella', mean: 960, sigma: 100) }
  let(:godzilla) { Player.create(name: 'Godzilla', key: 'godzilla', mean: 800, sigma: 90) }

  let(:match_1) { Match.create(winner_key: bob.key, loser_key: godzilla.key) }
  let(:match_2) { Match.create(winner_key: bella.key, loser_key: godzilla.key) }
  let(:match_3) { Match.create(winner_key: bob.key, loser_key: godzilla.key) }

  let(:create_players) { bob and bella and godzilla }
  let(:create_leaderboard_objects) { match_1 and match_2 and match_3 and nil }

  scenario 'a viewer sees tournament results for most recent tournament' do
    create_players
    create_leaderboard_objects

    visit tournament_path
    expect(page).to have_content I18n.t('leaderboard.title').upcase

    expect(page).to have_content I18n.t('leaderboard.rank')
    expect(page).to have_content I18n.t('leaderboard.name')
    expect(page).to have_content I18n.t('leaderboard.record')

    expect(page).to have_content '1 Bob 2-0'
    expect(page).to have_content '2 Bella 1-0'
    expect(page).to have_content '3 Godzilla 0-3'
  end
end