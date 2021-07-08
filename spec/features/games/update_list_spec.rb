require 'rails_helper'

feature 'User can update list of owned games', "
  In order to releventiate data
  I'd like to update games
" do

  given(:user){ create(:user) }
  given(:game){ create(:game) }
  given!(:purchase){ create(:purchase, owner: user, game: game) }

  scenario 'Authenticated user tries to update list of owned games' do
    visit root_path
    click_on 'Sign in'

    click_on 'Look for new games and update playtime'
    new_games = [user.games.count - 1, 0].max
    expect(page).to have_content "#{new_games} new #{'game'.pluralize(new_games)} found."
  end
end