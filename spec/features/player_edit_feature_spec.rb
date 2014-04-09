require 'spec_helper'

feature 'On the player edit page:', :js do
  let!(:bob) { Player.create(name: 'Bob', key: '93fb9466661fe0da4f07df6a745ffb81', mean: 800, sigma: 100, last_tournament_date: 2.days.ago) }

  scenario 'a viewer can edit a player name' do |example|
    visit player_path key: bob.key
    click_link I18n.t('player.edit.link')

    step '1. the edit page is available', current: example do
      expect(current_path).to eq edit_player_path key: bob.key
    end

    step '2. the current name populates the text field', current: example do
      within '.player-name-field' do
        expect(page).to have_field('player_name', with: 'Bob')
      end
    end

    step '3. fill in new name, submit form', current: example do
      fill_in 'player_name', with: 'Bella'
      click_on I18n.t('player.edit.commit').upcase
    end

    step '4. viewer returns to player page with updated name', current: example do
      expect(current_path).to eq player_path key: bob.key
      expect(page).to have_content 'Bella'
      expect(page).to_not have_content 'Bob'
    end
  end
end