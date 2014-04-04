require 'spec_helper'

feature 'at the players URL:' do
  let!(:bob) { Player.create(name: 'Bob', key: 'bob') }
  let!(:sally) { Player.create(name: 'Sally', key: 'sally') }
  let!(:godzilla) { Player.create(name: 'Godzilla', key: 'godzilla') }

  scenario 'it shows a list of players' do
    step '1. go to matches path' do
      visit players_path
    end

    step '2. expect to see all players in alphabetical order of player name as links' do
      expect(page).to have_content I18n.t('players.title')

      expect(page).to have_css 'tr:eq(2)', text: 'Bob'
      expect(page).to have_css 'tr:eq(3)', text: 'Godzilla'
      expect(page).to have_css 'tr:eq(4)', text: 'Sally'
    end

    step '3. click Bob link' do
      click_link 'Bob'
    end

    step '4. expect URL to be updated' do
      expect(current_path).to eq(player_path('bob'))
    end
  end
end