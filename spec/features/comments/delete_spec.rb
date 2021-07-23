require 'rails_helper'

feature 'User can delete comment', "
  I'd like to delete comment
  If i change my opinion about review
" do

  given(:user) { create(:user) }
  given(:game) { create(:game) }
  given!(:purchase) { create(:purchase, game: game, owner: user) }
  given(:review) { create(:review, game: game, author: user) }
  given!(:comment) { create(:comment, review: review, author: user) }

  describe 'authenticated user', js: true do
    background do
      visit root_path
      click_on 'Sign in'
    end

    scenario 'tries to delete his comment' do
      visit game_path(game)

      within '.comment' do
        click_on 'Delete'
      end

      expect(page).to_not have_content comment.text
    end

    scenario "tries to delete other's review" do
      other_user = FactoryBot.create(:user, id: 100)
      other_comment = FactoryBot.create(:comment, author: other_user, review: review)
      visit game_path(game)

      within "#comment_#{other_comment.id}" do
        expect(page).to_not have_content 'Delete'
      end
    end

    describe 'multiple sessions' do
      scenario 'user tries to delete his comment' do
        Capybara.using_session :user do
          visit root_path
          click_on 'Sign in'
          visit game_path(game)
        end

        Capybara.using_session :user2 do
          visit game_path(game)
        end

        Capybara.using_session :user do
          within '.comment' do
            click_on 'Delete'
          end
        end

        Capybara.using_session :user2 do
          expect(page).to_not have_content comment.text
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to delete comment' do
    visit root_path
    click_on 'Sign in'
    visit game_path(game)

    within '.comment' do
      expect(page).to_not have_content 'Delete'
    end
  end
end