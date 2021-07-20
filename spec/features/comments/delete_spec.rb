require 'rails_helper'

feature 'User can delete comment', "
  I'd like to delete comment
  If i change my opinion about review
" do

  given(:user) { create(:user) }
  given(:game) { create(:game) }
  given!(:purchase) { create(:purchase, game: game, owner: user) }
  given(:review) { create(:review, game: game, author: user) }
  given!(:comment) { create(:comment, review: review, author: user) }

  scenario 'User tries to delete his comment', js: true do
    visit root_path
    click_on 'Sign in'
    visit game_path(game)

    within '.comment' do
      click_on 'Delete'
    end

    expect(page).to_not have_content comment.text
  end

  scenario "User tries to delete other's review" do
  end
end