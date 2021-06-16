require 'rails_helper'

feature 'User can view owned games', "
  In order to rate them
  I'd like to view games
" do

  describe 'Tries to view list of owned games after authentication' do
    scenario 'with public account' do
      visit root_path
      click_on 'Sign in'

      SteamCover.owned_games(User.last).each do |game|
        game_genres = SteamCover.game_details(game['appid'])["data"]["genres"].map{|x|x['description']}.join(', ')
        expect(page).to have_content game['name']
        expect(page).to have_content game_genres
      end
    end

    scenario 'with private account' do
      OmniAuth.config.add_mock(:steam, { uid: 76561199154278084, info: { nickname: 'tester' } })
      visit user_steam_omniauth_callback_path

      expect(page).to have_content 'Make your account public'
    end
  end
end