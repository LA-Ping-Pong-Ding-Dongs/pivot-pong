require 'spec_helper'

feature 'Team Names', js: true do
  it 'can create a team' do
    visit doubles_matches_path

    within '#winner' do
      fill_in 'Name', with: 'Coffee Lovers'
      fill_in 'Player 1', with: 'Random Person'
      fill_in 'Player 2', with: 'Other Different Person'
    end

    within '#loser' do
      fill_in 'Name', with: 'Coffee Haters'
      fill_in 'Player 1', with: 'Bland Person'
      fill_in 'Player 2', with: 'Other Bland Person'
    end

    click_on 'Add Match'

    within '#history tbody tr' do
      page.should have_content('Coffee Lovers')
      page.should have_content('Coffee Haters')
    end

    click_link 'delete'
  end
end
