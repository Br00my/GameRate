require 'rails_helper'

feature 'User can create reviews', "
  In order to share exeperience and rate game
  I'd like to create reviews
" do

  given(:game){ create(:game) }
  given!(:purchase) { create(:purchase, game: game) }

  describe 'Authenticated user', js: true do
    background do
      visit root_path
      click_on 'Sign in'
      visit game_path(game)
    end

    scenario 'tries to publish valid review' do
      review_text = 'Versatile gameplay and interesting plot'
      find('#star5').click
      fill_in 'text', with: review_text
      click_on 'Publish'
      within '.review' do
        expect(page).to have_content review_text
        expect(page).to have_content 5
      end
    end

    scenario 'tries to publish invalid review' do
      find('#star5').click
      click_on 'Publish'
      expect(page).to have_content 'Your review was not published. Both star rate and text are needed.'
    end

    scenario 'tries to publish more than one review' do
      review_text = 'Versatile gameplay and interesting plot'
      find('#star5').click
      fill_in 'text', with: review_text
      click_on 'Publish'
      expect(page).to_not have_selector '.review_form'

    end
  end

  scenario 'Unauthenticated user tries to publish review' do
    visit game_path(game)

    expect(page).to_not have_selector '.review_form'
  end
end