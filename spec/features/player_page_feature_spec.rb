require 'spec_helper'

feature 'On the player show page:', :js do
  let(:bob) { Player.create(name: 'Bob', key: 'bob', mean: 800, sigma: 100) }
  let(:sally) { Player.create(name: 'Sally', key: 'sally', mean: 2105, sigma: 60) }

  let(:match_1) { Match.create(winner_key: bob.key, loser_key: sally.key, created_at: DateTime.new(2014, 2, 4)) }
  let(:match_2) { Match.create(winner_key: bob.key, loser_key: sally.key, created_at: DateTime.new(2012, 1, 18)) }
  let(:match_3) { Match.create(winner_key: sally.key, loser_key: bob.key, created_at: DateTime.new(2012, 1, 17)) }
  let(:match_4) { Match.create(winner_key: bob.key, loser_key: sally.key, created_at: DateTime.new(2012, 1, 16)) }

  let(:create_matches) { match_1 and match_2 and match_3 and match_4 }

  scenario 'shows player information' do |example|
    create_matches
    visit player_path(bob)

    #player name
    expect(page).to have_content "#{I18n.t('player.title')} Bob"

    #overall record
    expect(page).to have_content "#{I18n.t('player_info.record.overall')} 3-1 (75.0%)"

    #recent matches
    expect(page).to have_content "#{I18n.t('player.recent_matches.won')} Sally #{I18n.t('player.recent_matches.on_date')} 02/04/2014"
    expect(page).to have_content "#{I18n.t('player.recent_matches.won')} Sally #{I18n.t('player.recent_matches.on_date')} 01/18/2012"
    expect(page).to have_content "#{I18n.t('player.recent_matches.lost')} Sally #{I18n.t('player.recent_matches.on_date')} 01/17/2012"
    expect(page).to have_content "#{I18n.t('player.recent_matches.won')} Sally #{I18n.t('player.recent_matches.on_date')} 01/16/2012"

    #streak
    expect(page).to have_content "#{I18n.t('player.streak.title')} 2#{I18n.t('player.streak.type.winner')}"
  end
end