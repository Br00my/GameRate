require 'rails_helper'

feature 'User can create comments', "
  In order to express opinion about review
  I'd like to create comment
" do

  given(:user){ create(:user) }
  given(:game){ create(:game) }
  given!(:purchase){ create(:purchase, game: game, owner: user) }
  given!(:review){ create(:review, author: user, game: game) }

  describe 'Authenticated user', js: true do
    background do
      visit root_path
      click_on 'Sign in'
    end

    scenario 'tries to create one comment on a review with valid attributes' do
      visit game_path(game)

      comment_text = 'Agreed. Game deserves a high score.'

      fill_in 'text', with: comment_text
      click_on 'Publish'

      expect(page).to have_content 'Your comment was successfully published.'
      expect(page).to have_content comment_text
    end

    scenario 'tries to create comment on a review with invalid attributes' do
      visit game_path(game)

      fill_in 'text', with: ''
      click_on 'Publish'

      expect(page).to have_content 'Your comment was not published. Text can not be empty.'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to create comment on a review' do
      visit game_path(game)

      expect(page).to_not have_css '.comment_create_btn'
    end
  end
end