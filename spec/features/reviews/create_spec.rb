require 'rails_helper'

feature 'User can create reviews', "
  In order to share exeperience and rate game
  I'd like to create reviews
" do

  given(:user){ create(:user) }
  given(:game){ create(:game) }
  given!(:purchase) { create(:purchase, user: user, game: game, playtime: 10) }

  describe 'Authenticated user' do
    scenario 'tries to review game' do
      visit root_path
      click_on 'Sign in'

      visit game_path(game)
      choose '#star5'
      fill_in 'Text', with: 'Versatile gameplay and interesting plot'
      click_on 'Publish'

      visit root_path
      check '#star5'
    end
  end
end