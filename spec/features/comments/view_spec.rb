require 'rails_helper'

feature 'User can view comments', "
  In order to know players' opinions about the review
  I'd like to view comments
" do

  given(:user) { create(:user) }
  given(:game) { create(:game) }
  given!(:purchase) { create(:purchase, game: game, owner: user) }
  given(:review) { create(:review, game: game, author: user) }
  given!(:comment) { create(:comment, review: review, author: user) }

  scenario 'User tries to view comment on specific review' do
    visit game_path(game)

    expect(page).to have_content comment.text
  end
end