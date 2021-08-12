require 'rails_helper'

feature 'User can delete review', "
  In order to change the game rate
  I'd like to delete review
" do

  given(:user) { create(:user) }
  given(:game) { create(:game) }
  given!(:purchase) { create(:purchase, game: game, owner: user) }
  given!(:review) { create(:review, game: game, author: user) }

  scenario 'User tries to delete his review', js: true do
    visit root_path
    click_on 'Sign in'
    visit game_path(game)
    click_on 'Delete'
    expect(page).to have_content 'Your review was successfully deleted.'
    expect(page).to_not have_content review.text
  end

  scenario "User tries to delete other's review" do
    other_user = FactoryBot.create(:user, id: 1000)
    FactoryBot.create(:purchase, owner: other_user, game: game)
    other_user_review = FactoryBot.create(:review, author: other_user, game: game)
    visit root_path
    click_on 'Sign in'
    visit game_path(game)
    within "#review_#{other_user_review.id}" do
      expect(page).to_not have_content 'Delete'
    end
  end

  describe 'multiple sessions' do
    scenario 'User tries to delete his review', js: true do
      Capybara.using_session :user do
        visit root_path
        click_on 'Sign in'
        visit game_path(game)
      end

      Capybara.using_session :user2 do
        visit game_path(game)
      end

      Capybara.using_session :user do
        click_on 'Delete'
      end

      Capybara.using_session :user2 do
        expect(page).to_not have_content review.text
          expect(page).to have_content '0.0'
      end
    end
  end
end