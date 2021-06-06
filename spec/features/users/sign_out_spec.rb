require 'rails_helper'

feature 'User can log out', "
  In order to leave session
  As an authenticated user
  I'd like to be able to sign out
" do

  scenario 'Tries to sign out' do
    visit root_path
    click_on 'Sign in'

    click_on 'Sign out'
  end
end
