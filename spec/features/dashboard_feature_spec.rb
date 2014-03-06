require 'spec_helper'

feature 'On the dashboard:', :js do
  let(:player_one) { Player.create(name: 'Bob', key: 'bob', mean: 2300, sigma: 35, last_tournament_date: 5.weeks.ago) }
  let(:player_two) { Player.create(name: 'Sally', key: 'sally', mean: 2105, sigma: 60, last_tournament_date: 1.week.ago) }

  let!(:godzilla) { FactoryGirl.create :player, name: 'Godzilla'}
  let!(:mothra) { FactoryGirl.create :player, name: 'Mothra'}
  let!(:match) { FactoryGirl.create :match, winner_key: godzilla.key, loser_key: mothra.key }

  scenario 'a player can enter a match.' do |example|
    visit root_path

    step '1. fill in the winner and the loser', current: example do
      fill_in I18n.t('match.form.winner_label'), with: 'Bob'
      fill_in I18n.t('match.form.loser_label'), with: 'Templeton'

      click_on I18n.t('match.form.commit')
    end

    step '2. the last match results should update to reflect the entry', current: example do
      expect(page).to have_content(['Bob', I18n.t('match.last.win_verb'), 'Templeton'].join(' '))
    end
  end

  scenario 'a viewer can see all of the players and their data' do
    player_one
    player_two

    visit root_path

    expect(page).to have_content('Bob')
    expect(page).to have_content(2300)

    expect(page).to have_content('Sally')
    expect(page).to have_content(2105)
  end

  scenario 'a viewer can see existing matches' do
    visit root_path

    expect(page).to have_content "Godzilla #{I18n.t('match.last.win_verb')} Mothra"
  end
end
