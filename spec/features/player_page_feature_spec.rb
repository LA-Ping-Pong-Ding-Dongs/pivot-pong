require 'spec_helper'

feature 'On the player show page:', :js do
  let(:bob) { Player.create(name: 'Bob', key: 'bob', mean: 800, sigma: 100) }
  let(:sally) { Player.create(name: 'Sally', key: 'sally', mean: 2105, sigma: 60) }

  let(:match_1) { Match.create(winner_key: bob.key, loser_key: sally.key, created_at: DateTime.new(2014, 2, 4)) }
  let(:match_2) { Match.create(winner_key: bob.key, loser_key: sally.key, created_at: DateTime.new(2012, 1, 18)) }

  let(:create_matches) { match_1 and match_2 }

  scenario 'shows player information' do |example|
    create_matches
    visit player_path(bob)

    expect(page).to have_content "#{I18n.t('player.title')} Bob"
    expect(page).to have_content '2-0 (100.0%)'
    expect(page).to have_content "#{I18n.t('player.recent_matches.won')} Sally #{I18n.t('player.recent_matches.on')} 02/04/2014"
    expect(page).to have_content "#{I18n.t('player.recent_matches.won')} Sally #{I18n.t('player.recent_matches.on')} 01/18/2012"
  end
end