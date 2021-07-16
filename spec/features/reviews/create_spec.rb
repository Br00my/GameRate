require 'rails_helper'

feature 'User can create reviews', "
  In order to share exeperience and rate game
  I'd like to create reviews
" do

  given(:user){ create(:user) }
  given(:game){ create(:game) }
  given!(:purchase) { create(:purchase, game: game, owner: user) }

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
      expect(page).to have_content 'Your review was successfully published.'
      within '.review' do
        expect(find('.review_rate')[:style]).to eq '--rating: 5;'
        expect(page).to have_content review_text
      end
      visit root_path
      expect(page).to have_content '5.0/5.0'
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
      expect(page).to_not have_selector '.review_create_form'
      click_on 'GameRate'
      find('.game').click
      expect(page).to_not have_selector '.review_create_form'
    end

    scenario 'tries to publish review to game he does not own' do
      other_user = FactoryBot.create(:user, id: 100)
      other_game = FactoryBot.create(:game)
      FactoryBot.create(:purchase, owner: other_user, game: other_game)
      visit game_path(other_game)

      expect(page).to_not have_css '.review_create_form'
    end
  end

  scenario 'Unauthenticated user tries to publish review' do
    visit game_path(game)

    expect(page).to_not have_selector '.review_create_form'
  end
end