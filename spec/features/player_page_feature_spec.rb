require 'spec_helper'

feature 'On the player show page:', :js do
  let(:bob) { Player.create(name: 'Bob', key: 'f2b8be6ba879e2b1bd1653852f1a33ab', mean: 800, sigma: 100) }
  let(:sally) { Player.create(name: 'Sally', key: '99ce27141314607c8d0d3cec9807c67f', mean: 2105, sigma: 60) }

  let(:tournament) { TournamentRecord.create(start_date: 3.weeks.ago, end_date: 2.weeks.ago, winner_key: 'bob') }

  let(:match_1) { Match.create(winner_key: bob.key, loser_key: sally.key, created_at: DateTime.new(2014, 2, 4)) }
  let(:match_2) { Match.create(winner_key: bob.key, loser_key: sally.key, created_at: DateTime.new(2012, 1, 18)) }
  let(:match_3) { Match.create(winner_key: sally.key, loser_key: bob.key, created_at: DateTime.new(2012, 1, 17)) }
  let(:match_4) { Match.create(winner_key: bob.key, loser_key: sally.key, created_at: DateTime.new(2012, 1, 16)) }

  let(:create_matches) { match_1 and match_2 and match_3 and match_4 }

  scenario 'shows player information' do |example|
    create_matches
    visit player_path(bob)

    step '1. a viewer can see a player name, record, recent matches and current streak', current: example do
      #player name
      expect(page).to have_content "#{I18n.t('player.title')} Bob"

      #overall record
      expect(page).to have_content I18n.t('player_info.record.overall').upcase
      within '.winning' do
        expect(page).to have_content "3-1 (75.0%)"
      end

      #recent matches
      expect(page).to have_content "#{I18n.t('player.recent_matches.won')} Sally #{I18n.t('player.recent_matches.on_date')} 02/04/2014"
      expect(page).to have_content "#{I18n.t('player.recent_matches.won')} Sally #{I18n.t('player.recent_matches.on_date')} 01/18/2012"
      expect(page).to have_content "#{I18n.t('player.recent_matches.lost')} Sally #{I18n.t('player.recent_matches.on_date')} 01/17/2012"
      expect(page).to have_content "#{I18n.t('player.recent_matches.won')} Sally #{I18n.t('player.recent_matches.on_date')} 01/16/2012"

      # badges
      expect(page).to_not have_css '.tournament-winner-trophy'

      #streak
      expect(page).to have_content I18n.t('player.streak.title').upcase
      within '.hot-streak' do
        expect(page).to have_content "2#{I18n.t('player.streak.type.winner')}"
        expect(page).to have_css("img[src='/assets/smoke.png']")
      end
    end

    step '2. a viewer can return to the dashboard page', current: example do
      click_link I18n.t('dashboard.link_title').upcase

      expect(current_path).to eq root_path
    end
  end

  scenario 'player can link to edit name' do
    bob
    visit player_path(bob)
    click_link 'edit_player_link'

    expect(current_path).to eq edit_player_path bob.key
  end
end
