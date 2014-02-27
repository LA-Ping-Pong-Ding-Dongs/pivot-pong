require 'spec_helper'

feature 'On the dashboard:', :js do
  background { visit root_path }

  scenario 'a player can enter a match.' do |example|

    step '1. fill in the winner and the loser', current: example do
      fill_in I18n.t('match.form.winner_label'), with: 'Bob'
      fill_in I18n.t('match.form.loser_label'), with: 'Templeton'

      click_on I18n.t('match.form.commit')
    end

    step '2. the last match results should update to reflect the entry', current: example do
      expect(page).to have_content(['Bob',I18n.t('match.last.win_verb'),'Templeton'].join(' '))
    end

  end
end