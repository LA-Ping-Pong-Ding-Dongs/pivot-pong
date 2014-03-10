require 'spec_helper'

feature 'On the dashboard:', :js do
  let(:player_one) { Player.create(name: 'Bob', key: 'bob', mean: 2300, sigma: 35, last_tournament_date: 5.weeks.ago) }
  let(:player_two) { Player.create(name: 'Sally', key: 'sally', mean: 2105, sigma: 60, last_tournament_date: 1.week.ago) }

  let(:create_players) { player_one and player_two and nil }
  let(:create_match) { Match.create winner_key: player_one.key, loser_key: player_two.key }

  scenario 'a player can enter a match.' do |example|
    visit root_path

    step '1. fill in the winner and the loser', current: example do
      fill_in I18n.t('match.form.winner_label').upcase, with: 'Bob'
      fill_in I18n.t('match.form.loser_label').upcase, with: 'Templeton'

      click_on I18n.t('match.form.commit')
    end

    step '2. the last match results should update to reflect the entry', current: example do
      expect(page).to have_content(['Bob', I18n.t('match.last.win_verb'), 'Templeton'].join(' '))
    end
  end

  scenario 'a viewer can see all of the players and their data' do
    create_players
    visit root_path

    expect(page).to have_content('Bob')
    expect(page).to have_content(2300)

    expect(page).to have_content('Sally')
    expect(page).to have_content(2105)
  end

  scenario 'a viewer can see existing matches' do
    create_match
    visit root_path

    expect(page).to have_content "Bob #{I18n.t('match.last.win_verb')} Sally"
  end

  scenario 'a user can view player info' do
    create_match
    visit root_path

    expect(page).to have_content('Bob')

    # svg selection seems to generally suck on attributes, this is a work around
    page.execute_script "window.location = $('a').filter('[title=Bob]').first().attr('href');"

    within '#player_info' do
      expect(page).to have_content 'Bob'
      expect(page).to have_content '1-0 (100.0%)'
    end
  end

end
