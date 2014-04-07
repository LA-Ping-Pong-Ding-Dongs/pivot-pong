require 'spec_helper'

feature 'at the players URL:' do
  let!(:bob) { Player.create(name: 'Bob', key: 'bob') }
  let!(:sally) { Player.create(name: 'Sally', key: 'sally') }
  let!(:godzilla) { Player.create(name: 'Godzilla', key: 'godzilla') }

  scenario 'it shows a list of players' do |example|
    step '1. go to matches path', current: example do
      visit players_path
    end

    step '2. expect to see all players in alphabetical order of player name as links', current: example do
      expect(page).to have_content I18n.t('players.title')

      expect(page).to have_css 'tr:eq(2)', text: 'Bob'
      expect(page).to have_css 'tr:eq(3)', text: 'Godzilla'
      expect(page).to have_css 'tr:eq(4)', text: 'Sally'
    end

    step '3. click Bob link', current: example do
      click_link 'Bob'
    end

    step '4. expect URL to be updated', current: example do
      expect(current_path).to eq(player_path('bob'))
    end
  end

  scenario 'it has a link to the dashboard' do
    visit players_path
    click_link I18n.t('dashboard.link_title').upcase

    expect(current_path).to eq root_path
  end
end