require 'rails_helper'

feature 'User can edit reviews', "
  In order to correct text or change the rate
  I'd like to edit reviews
" do

  given(:user) { create(:user) }
  given(:game) { create(:game) }
  given!(:purchase) { create(:purchase, game: game, owner: user) }
  given!(:review) { create(:review, game: game, author: user) }

  describe 'Authorized user' do
    describe 'tries to edit review', js: true do
      background do
        visit root_path
        click_on 'Sign in'
        visit game_path(game)
      end

      scenario 'tries to edit review with valid attributes' do
        click_on 'Edit'
        review_text = 'Versatile gameplay and interesting plot'
        find('#star5').click
        within '.review_edit_form' do
          fill_in 'text', with: review_text
          click_on 'Confirm'
        end
        within '.review' do
          expect(find('.review_rate')[:style]).to eq '--rating: 5;'
          expect(page).to have_content review_text
        end
      end

      scenario 'tries to edit review with invalid attributes' do
        click_on 'Edit'
        find('#star5').click
        within '.review_edit_form' do
          fill_in 'text', with: ''
          click_on 'Confirm'
        end
        expect(page).to have_content 'Your review was not edited. Both star rate and text are needed.'
      end

      scenario 'tries to cancel review editing' do
        click_on 'Edit'
        within '.review_edit_form' do
          click_on 'Cancel'
        end
        expect(page).to_not have_css '.review_edit_form'
      end

      scenario "tries to edit other user's review" do
        other_user = FactoryBot.create(:user, id: 100)
        FactoryBot.create(:purchase, owner: other_user, game: game)
        other_user_review = FactoryBot.create(:review, author: other_user, game: game)
        visit game_path(game)

        within "#review_#{other_user_review.id}" do
          expect(page).to_not have_content 'Edit'
        end
      end

      describe 'multiple sessions' do
        scenario 'tries to edit review' do
          Capybara.using_session :user do
            visit root_path
            click_on 'Sign in'
            visit game_path(game)
          end

          Capybara.using_session :user2 do
            visit game_path(game)
          end

          review_text = 'Versatile gameplay and interesting plot'
          Capybara.using_session :user do
            click_on 'Edit'
            find('#star5').click
            within '.review_edit_form' do
              fill_in 'text', with: review_text
              click_on 'Confirm'
            end
          end

          Capybara.using_session :user2 do
            expect(page).to have_content review_text
          expect(page).to have_content '5.0'
          end
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to publish review' do
    visit game_path(game)

    expect(page).to_not have_css '.review_edit_form'
  end
end