require 'spec_helper'

feature 'On the Tournament Leaderboard' do
  let(:bob) { Player.create(name: 'Bob', key: 'abfa9dba916f2e487d64ccdb658ce6d0', mean: 1200, sigma: 140) }
  let(:bella) { Player.create(name: 'Bella', key: '9621b65bf7c398ee7fd4a708a8171a54', mean: 960, sigma: 100) }
  let(:godzilla) { Player.create(name: 'Godzilla', key: '544151cd41aaa51edfd4a0bd2ccbef03', mean: 800, sigma: 90) }

  let(:match_1) { Match.create(winner_key: bob.key, loser_key: godzilla.key) }
  let(:match_2) { Match.create(winner_key: bella.key, loser_key: godzilla.key) }
  let(:match_3) { Match.create(winner_key: bob.key, loser_key: godzilla.key) }

  let(:create_players) { bob and bella and godzilla }
  let(:create_leaderboard_objects) { match_1 and match_2 and match_3 and nil }

  scenario 'a viewer sees tournament results for most recent tournament' do |example|
    create_players
    create_leaderboard_objects

    visit tournament_path

    step '1. view current tournament information', current: example do
      expect(page).to have_content I18n.t('leaderboard.title').upcase

      expect(page).to have_content I18n.t('leaderboard.rank')
      expect(page).to have_content I18n.t('leaderboard.name')
      expect(page).to have_content I18n.t('leaderboard.record')

      expect(page).to have_content '1 Bob 2-0'
      expect(page).to have_content '2 Bella 1-0'
      expect(page).to have_content '3 Godzilla 0-3'
    end

    step '2. return to the dashboard', current: example do
      click_link I18n.t('dashboard.link_title').upcase

      expect(current_path).to eq root_path
    end
  end
end