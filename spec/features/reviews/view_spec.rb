require 'rails_helper'

feature 'User can view reviews', "
  In order to know players' opinions about the game
  I'd like to view reviews
" do

  given(:user) { create(:user) }
  given(:game) { create(:game) }
  given!(:purchase) { create(:purchase, game: game, owner: user) }
  given!(:review) { create(:review, game: game, author: user) }

  scenario 'User tries to view reviews of specific game' do
    visit game_path(game)
    expect(find('.review_rate')[:style]).to eq '--rating: 1;'
    expect(page).to have_content review.text
  end
end