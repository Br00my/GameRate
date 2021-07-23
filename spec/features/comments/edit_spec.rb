require 'rails_helper'

feature 'User can edit reviews', "
  In order to correct text or change the rate
  I'd like to edit reviews
" do

  given(:user) { create(:user) }
  given(:game) { create(:game) }
  given!(:purchase) { create(:purchase, game: game, owner: user) }
  given!(:review) { create(:review, game: game, author: user) }
  given!(:comment) { create(:comment, review: review, author: user) }

  describe 'Authenticated user', js: true do
    background do
      visit root_path
      click_on 'Sign in'
      visit game_path(game)
    end

    scenario 'tries to edit comment with valid attributes' do
      comment_text = 'You are wrong'
      within '.comment' do
        click_on 'Edit'
        fill_in 'text', with: comment_text
        click_on 'Edit'
      end

      expect(page).to have_content 'Your comment was successfully edited.'
      expect(page).to have_content comment_text
    end

    scenario 'tries to edit comment with invalid attributes' do
      within '.comment' do
        click_on 'Edit'
        fill_in 'text', with: ''
        click_on 'Edit'
      end

      expect(page).to have_content 'Your comment was not edited. Text can not be blank'
    end

    scenario 'tries to cancel comment editing' do
      within '.comment' do
        click_on 'Edit'
        click_on 'Cancel'
      end

      expect(page).to_not have_css '.comment_edit_review'
    end

    scenario "tries to edit other user's comment" do
      other_user = FactoryBot.create(:user, id: 100)
      other_comment = FactoryBot.create(:comment, author: other_user, review: review)
      visit game_path(game)

      within "#comment_#{other_comment.id}" do
        expect(page).to_not have_content 'Edit'
      end
    end

    describe 'multiple sessions' do
      scenario 'tries to edit comment' do
        Capybara.using_session :user do
          visit root_path
          click_on 'Sign in'
          visit game_path(game)
        end

        Capybara.using_session :user2 do
          visit game_path(game)
        end

        comment_text = 'You are wrong'
        Capybara.using_session :user do
          within '.comment' do
            click_on 'Edit'
            fill_in 'text', with: comment_text
            click_on 'Edit'
          end
        end

        Capybara.using_session :user2 do
          expect(page).to have_content comment_text
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to edit comment' do
    visit game_path(game)

    within '.comment' do
      expect(page).to_not have_content 'Edit'
    end
  end
end