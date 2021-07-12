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

      click_on 'Leave a comment'
      comment_text = 'Agreed. Game deserves a high score.'

      fill_in 'text', with: comment_text
      click_on 'Publish'

      expect(page).to have_content 'Your comment was successfully published.'
      expect(page).to have_content comment_text
    end

    scenario 'tries to create comment on a review with invalid attributes' do
      visit game_path(game)

      click_on 'Leave a comment'
      fill_in 'text', with: ''
      click_on 'Publish'

      expect(page).to have_content 'Your comment was not published. Text can not be empty.'
    end

    scenario 'tries to create comment on a review to game he does not own' do
      other_user = FactoryBot.create(:user, id: 100)
      other_game = FactoryBot.create(:game)
      FactoryBot.create(:purchase, game: other_game, owner: other_user)
      other_review = FactoryBot.create(:review, author: other_user, game: other_game)

      visit game_path(other_game)

      expect(page).to_not have_css '.comment_create_form'
    end

    scenario 'tries to cancel comment creation' do
      visit game_path(game)

      click_on 'Leave a comment'
      click_on 'Cancel'
      expect(page).to_not have_css '.comment_create_form'
    end

    scenario 'tries to comment on two reviews' do
      other_user = FactoryBot.create(:user, id: 100)
      FactoryBot.create(:purchase, game: game, owner: other_user)
      other_review = FactoryBot.create(:review, author: other_user, game: game)

      visit game_path(game)

      within "#review_#{review.id}" do
        click_on 'Leave a comment'
        comment_text = 'Agreed. Game deserves a high score.'
        fill_in 'text', with: comment_text
        click_on 'Publish'

        expect(page).to have_content comment_text
      end

      within "#review_#{other_review.id}" do
        click_on 'Leave a comment'
        comment_text = "You're wrong"
        fill_in 'text', with: comment_text
        click_on 'Publish'

        expect(page).to have_content comment_text
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to create comment on a review' do
      visit game_path(game)

      expect(page).to_not have_css '.comment_create_btn'
    end
  end
end