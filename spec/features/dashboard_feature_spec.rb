require 'spec_helper'

feature 'On the dashboard:', :js do
  let(:match_time) { 1.hour.ago }

  let(:bob) { Player.create(name: 'Bob', key: 'dda629140ba03c2e861a248d2c2579cb', mean: 800, sigma: 100, last_tournament_date: 5.weeks.ago) }
  let(:sally) { Player.create(name: 'Sally', key: '99ce27141314607c8d0d3cec9807c67f', mean: 2105, sigma: 60, last_tournament_date: 1.week.ago) }
  let(:godzilla) { Player.create(name: 'Godzilla', key: 'f2b8be6ba879e2b1bd1653852f1a33ab') }

  let(:match_1) { Match.create(winner_key: bob.key, loser_key: sally.key, created_at: match_time) }
  let(:match_2) { Match.create(winner_key: godzilla.key, loser_key: sally.key) }
  let(:match_3) { Match.create(winner_key: godzilla.key, loser_key: bob.key) }

  let(:create_players) { bob and sally and nil }
  let(:create_leaderboard_objects) { match_1 and match_2 and match_3 and nil }

  scenario 'a player can enter a match' do |example|
    bob
    visit root_path

    step '1. fill in the winner and the loser', current: example do
      expect(page).to have_css '#winner_suggestions'
      fill_in I18n.t('match.form.winner_label').upcase, with: 'Bob'
      fill_in I18n.t('match.form.loser_label').upcase, with: 'Templeton'

      click_on I18n.t('match.form.commit').upcase
      expect(page).to have_content '1-0'
    end

    step '2. The players ratings get updated', current: example do
      visit current_url

      expect(page).to have_content(865)
      expect(page).to have_content(742)
    end

    step '3. the last match results should update to reflect the entry', current: example do
      find('.recent-matches-link').click

      expect(page).to have_css '.winner', text: 'Bob'
      expect(page).to have_css '.loser', text: 'Templeton'
    end
  end

  scenario 'as they enter a match winner a player can click on a name from a dropdown' do |example|
    create_players
    visit root_path

    step '1. type initial name string and expect pop up list to display', current: example do
      fill_in I18n.t('match.form.winner_label').upcase, with: 'b'
      within '.winner-field .search' do
        expect(page).to have_content 'Bob'
      end
    end

    step '2. clicking a name will fill in winner with player name', current: example do
      within '.winner-field .search' do
        page.find('li', 'Bob').click
      end

      expect(page).to have_field('match_winner', with: 'Bob')

      within '.winner-field .search' do
        expect(page).to_not have_selector('li')
      end
    end
  end

  scenario 'as they enter a match loser a player can click on a name from a dropdown' do |example|
    create_players
    visit root_path

    step '1. type initial name string and expect pop up list to display', current: example do
      fill_in I18n.t('match.form.loser_label').upcase, with: 'b'
      within '.loser-field .search' do
        expect(page).to have_content 'Bob'
      end
    end

    step '2. clicking a name will fill in loser with player name', current: example do
      within '.loser-field .search' do
        page.find('li', 'Bob').click
      end

      expect(page).to have_field('match_loser', with: 'Bob')

      within '.loser-field .search' do
        expect(page).to_not have_selector('li')
      end
    end
  end

  scenario 'a viewer can see all of the players and their data' do |example|
    create_players
    visit root_path

    step '1. players will be displayed on the dashboard', current: example do
      expect(page).to have_content('Bob')
      expect(page).to have_content(800)

      expect(page).to have_content('Sally')
      expect(page).to have_content(2105)
    end

    step '2. a viewer can go to players page', current: example do
      within '#player_info' do
        find('.all-players-link').click
      end

      expect(current_path).to eq players_path
    end
  end

  scenario 'a viewer can see existing matches' do |example|
    match_1
    visit root_path

    step '1. clicking recent matches tab will show recent matches', current: example do
      find('.recent-matches-link').click

      expect(page).to have_css '.winner', text: 'Bob'
      expect(page).to have_css '.loser', text: 'Sally'
    end

    step '2. a view can go to matches page by clicking recent matches title', current: example do
      click_link I18n.t('overlay.recent_matches.tab_title')
      within '#recent_matches_container' do
        click_link (I18n.t('recent_matches.title').upcase)
      end

      expect(current_path).to eq matches_path
    end
  end

  scenario 'a user can view player info' do |example|
    create_leaderboard_objects
    visit root_path

    expect(page).to have_content('Godzilla')

    # svg selection seems to generally suck on attributes, this is a work around
    page.execute_script "$('a').filter('[title=Godzilla]').first().click();"

    step '1. information is displayed in player info window', current: example do
      within '#player_info' do
        expect(page).to have_content 'Godzilla'
        expect(page).to have_content '2-0 (100.0%)'
        expect(page).to have_css '.hot-streak', text: '2W'
        expect(page).to have_css("img[src='/assets/smoke.png']")
      end
    end

    step '2. user can press escape to reload dashboard', current: example do
      expect(current_path).to eq "/players/#{godzilla.key}"
      find('#match_winner').native.send_keys(:Escape)
      expect(current_path).to eq '/'
    end

    step '3. user can click link to player show page', current: example do
      page.execute_script "$('a').filter('[title=Godzilla]').first().click();"

      within '#player_info' do
        click_link 'Godzilla'
      end

      expect(current_path).to eq player_path("#{godzilla.key}")
    end
  end

  scenario 'a viewer can see current tournament player rankings' do |example|
    create_leaderboard_objects
    visit root_path

    step '1. a viewer can see current tournament information', current: example do
      find('.recent-matches-link').click
      expect(page).to have_content I18n.t('player.recent_matches.title').upcase
      expect(page).to_not have_content I18n.t('leaderboard.title').upcase

      find('.leaderboard-link').click
      expect(page).to have_content I18n.t('leaderboard.title').upcase
      expect(page).to_not have_content I18n.t('player.recent_matches.title').upcase

      expect(page).to have_content 'Godzilla 2-0'
      expect(page).to have_content 'Bob 1-1'
      expect(page).to have_content 'Sally 0-2'
    end

    step '2. a view can click leaderboard title to go to leaderboard page', current: example do
      within '#leaderboard_container' do
        click_link I18n.t('leaderboard.title').upcase
      end

      expect(current_path).to eq tournament_path
    end
  end

  scenario 'a viewer can click a tooltip to learn about leaderboard rankings' do
    visit root_path

    find('#tooltip_link').click
    expect(page).to have_content I18n.t('overlay.tooltip.copy')
  end
end
