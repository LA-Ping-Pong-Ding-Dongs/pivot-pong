require 'spec_helper'

feature 'at the matches URL:' do
  let(:match_time) { 1.hour.ago }

  let(:bob) { Player.create(name: 'Bob', key: 'bob', mean: 800, sigma: 100, last_tournament_date: 5.weeks.ago) }
  let(:sally) { Player.create(name: 'Sally', key: 'sally', mean: 2105, sigma: 60, last_tournament_date: 1.week.ago) }
  let(:godzilla) { Player.create(name: 'Godzilla', key: 'godzilla') }

  let!(:match_1) { Match.create(winner_key: bob.key, loser_key: godzilla.key, created_at: match_time) }
  let!(:match_2) { Match.create(winner_key: godzilla.key, loser_key: sally.key, created_at: Time.now) }
  let!(:match_3) { Match.create(winner_key: sally.key, loser_key: bob.key, created_at: 2.hours.ago) }

  scenario 'it shows the first page of matches in reverse order' do

    execute_with_modified_constant(MatchesController, 'PAGE_SIZE', 2) do

      step '1. go to matches path' do
        visit matches_path
      end

      step '2. expect to see first page of all matches' do

        expect(page).to have_content I18n.t('matches.title')

        within 'tr:eq(2)' do
          expect(page).to have_css '.winner', text: 'Godzilla'
          expect(page).to have_css '.loser', text: 'Sally'
          expect(page).to have_css '.time', text: 'less than a minute ago'
        end

        within 'tr:eq(3)' do
          expect(page).to have_css '.winner', text: 'Bob'
          expect(page).to have_css '.loser', text: 'Godzilla'
          expect(page).to have_css '.time', text: '1 hour ago'
        end

        expect(page).to have_css '.last', text: 'Last'
      end
    end
  end

  scenario 'you can navigate to the last page from the first page' do

    execute_with_modified_constant(MatchesController, 'PAGE_SIZE', 2) do

      step '1. go to matches path' do
        visit matches_path
      end

      step '2. click on "Last" link' do
        click_link 'Last'
      end

      step '3. expect to see last page of all matches' do

        expect(page).to have_content I18n.t('matches.title')

        within 'tr:eq(2)' do
          expect(page).to have_css '.winner', text: 'Sally'
          expect(page).to have_css '.loser', text: 'Bob'
          expect(page).to have_css '.time', text: '2 hours ago'
        end

        expect(page).to have_css(".table-container tr", :count=>2)

      end
    end
  end
end