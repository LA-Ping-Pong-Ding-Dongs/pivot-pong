require 'spec_helper'

feature 'On the dashboard:', :js do
  let(:player_one) { Player.create(name: 'Bob', key: 'bob') }
  let(:player_two) { Player.create(name: 'Sally', key: 'sally') }

  scenario 'a player can enter a match.' do |example|
    visit root_path

    step '1. fill in the winner and the loser', current: example do
      fill_in I18n.t('match.form.winner_label'), with: 'Bob'
      fill_in I18n.t('match.form.loser_label'), with: 'Templeton'

      click_on I18n.t('match.form.commit')
    end

    step '2. the last match results should update to reflect the entry', current: example do
      expect(page).to have_content(['Bob',I18n.t('match.last.win_verb'),'Templeton'].join(' '))
    end
  end

  scenario 'a viewer can see all of the players and their data' do
    player_one
    player_two

    visit root_path

    #expect(page).to have_content(player_one.name)
    #expect(page).to have_content(player_two.name)
    #expect(page).to have_link(player_path(player_one))
    #expect(page).to have_link(player_path(player_two))
  end
end
