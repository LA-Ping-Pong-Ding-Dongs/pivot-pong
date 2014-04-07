require 'spec_helper'

feature 'On the dashboard:' do
  let(:match_time) { 1.hour.ago }

  let(:bob) { Player.create(name: 'Bob', key: 'bob', mean: 800, sigma: 100, last_tournament_date: 5.weeks.ago) }
  let(:sally) { Player.create(name: 'Sally', key: 'sally', mean: 2105, sigma: 60, last_tournament_date: 1.week.ago) }
  let(:godzilla) { Player.create(name: 'Godzilla', key: 'godzilla') }

  let(:create_players) { bob and sally and nil }

  scenario 'a player can enter a match.' do |example|
    bob
    visit root_path

    step '1. fill in the winner and the loser', current: example do
      expect(page).to_not have_css '#winner_suggestions'
      fill_in I18n.t('match.form.winner_label').upcase, with: 'Bob'
      fill_in I18n.t('match.form.loser_label').upcase, with: 'Templeton'

      click_button I18n.t('match.form.commit')
      expect(page).to have_content '1-0'
    end
  end

  scenario 'a viewer can see all of the players and their data' do |example|
    create_players
    visit root_path

    step '1. expect to see a list players and their ratings', current: example do
      expect(page).to have_content('Bob')
      expect(page).to have_content(800)

      expect(page).to have_content('Sally')
      expect(page).to have_content(2105)
    end

    step '2. a viewer can navigate to the players page', current: example do
      click_link I18n.t('players.title')

      expect(current_path).to eq players_path
    end
  end

end