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

      scenario 'with valid attributes' do
        click_on 'Edit'
        review_text = 'Versatile gameplay and interesting plot'
        find('#star5').click
        fill_in 'text', with: review_text
        click_on 'Edit'
        within '.review' do
          expect(find('.review_rate')[:style]).to eq '--rating: 5;'
          expect(page).to have_content review_text
        end
      end

      scenario 'with invalid attributes' do
        click_on 'Edit'
        find('#star5').click
        fill_in 'text', with: ''
        click_on 'Edit'
        expect(page).to have_content 'Your review was not edited. Both star rate and text are needed.'
      end
    end

    scenario "tries to edit other user's review" do
      other_user = FactoryBot.create(:user, id: 1000)
      FactoryBot.create(:purchase, owner: other_user, game: game)
      other_user_review = FactoryBot.create(:review, author: other_user, game: game)
      visit root_path
      click_on 'Sign in'
      visit game_path(game)
      within "#review_data_#{review.id}" do
        expect(page).to_not have_content '.review_edit_btn'
      end
    end
  end

  scenario 'Unauthenticated user tries to publish review' do
    visit game_path(game)

    expect(page).to_not have_selector '.review_edit_form'
  end
end