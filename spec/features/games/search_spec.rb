require 'rails_helper'

feature 'User can search for games', "
  In order to save time
  I'd like to search games
" do

  given(:user) { create(:user) }
  given(:searched_game) { create(:game) }
  given(:game) { create(:game, title: "Garry's mod") }

  scenario 'user tries to search for game', js: true do
    FactoryBot.create(:purchase, owner: user, game: searched_game)
    FactoryBot.create(:purchase, owner: user, game: game)
    visit root_path
    fill_in 'title', with: searched_game.title
    click_on 'Search'

    expect(page).to have_content searched_game.title
    expect(page).to_not have_content game.title
  end
end