require 'rails_helper'

feature 'User can log in', "
  In order to rate games
  As an authenticated user
  I'd like to be able to sign in
" do

  scenario 'user exists' do
    FactoryBot.create(:user)
    visit root_path
    click_on 'Sign in'

    expect(page).to have_content 'Successfully authenticated from Steam account.'
  end

    # scenario 'user does not exist' do
    #   click_on 'Sign in'
    # end
  # end
end
