require 'spec_helper'

feature 'at the recent_matches URL:' do
  let(:match_time) { 1.hour.ago }

  let(:bob) { Player.create(name: 'Bob', key: 'bob', mean: 800, sigma: 100, last_tournament_date: 5.weeks.ago) }
  let(:sally) { Player.create(name: 'Sally', key: 'sally', mean: 2105, sigma: 60, last_tournament_date: 1.week.ago) }
  let(:godzilla) { Player.create(name: 'Godzilla', key: 'godzilla') }

  let(:match_1) { Match.create(winner_key: bob.key, loser_key: godzilla.key, created_at: match_time) }
  let(:match_2) { Match.create(winner_key: godzilla.key, loser_key: sally.key, created_at: Time.now) }
  let(:match_3) { Match.create(winner_key: sally.key, loser_key: bob.key, created_at: 2.hours.ago) }

  scenario 'it shows all the matches in reverse order of time' do
    match_1
    match_2
    match_3

    step '1. go to recent_matches path' do
      visit matches_path
    end

    step '2. expect to see all matches' do
      expect(page).to have_content I18n.t('recent_matches.title')

      within 'tr:eq(2)' do
        expect(page).to have_css '.winner', text: 'Godzilla'
        expect(page).to have_css '.loser', text: 'Sally'
        expect(page).to have_css '.time', text: 'less than a minute ago'
      end

      within 'tr:eq(3)' do
        expect(page).to have_css '.winner', text: 'Bob'
        expect(page).to have_css '.loser', text: 'Godzilla'
        expect(page).to have_css '.time', text: '1 hour ago'
      end

      within 'tr:eq(4)' do
        expect(page).to have_css '.winner', text: 'Sally'
        expect(page).to have_css '.loser', text: 'Bob'
        expect(page).to have_css '.time', text: '2 hours ago'
      end
    end
  end
end