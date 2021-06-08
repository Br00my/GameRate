require 'rails_helper'

feature 'User can view owned games', "
  In order to rate them
  I'd like to view games
" do

  scenario 'view list of owned games after authentication' do
    visit root_path
    click_on 'Sign in'

    expect(page).to have_content 'Counter-Strike: Global Offensive'
  end
end