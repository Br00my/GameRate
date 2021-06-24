require 'rails_helper'

feature 'User can view owned games', "
  In order to rate them
  I'd like to view games
" do

  describe 'Tries to view list of owned games after authentication' do
    scenario 'with public account' do
      visit root_path
      click_on 'Sign in'

      Game.pluck(:title) do |game_title|
        expect(page).to have_content game_title
      end
    end

    scenario 'with private account' do
      OmniAuth.config.add_mock(:steam, { uid: 76561199154278084, info: { nickname: 'tester' } })
      visit root_path
      click_on 'Sign in'

      expect(page).to have_content 'Make your account public'
    end
  end
end