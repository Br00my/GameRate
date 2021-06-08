require 'rails_helper'

feature 'User can log in', "
  In order to rate games
  As an authenticated user
  I'd like to be able to sign in
" do

  scenario 'Tries to sign in with existing user' do
    FactoryBot.create(:user)
    visit root_path
    click_on 'Sign in'

    expect(page).to have_content 'Hi, tester! You can now rate games.'
  end

  scenario 'Tries to sign in without existing user' do
    visit root_path
    click_on 'Sign in'

    expect(page).to have_content 'Hi, tester! You can now rate games.'
    expect(page).to have_content 'Here are the games we found in your profile'
  end
end
