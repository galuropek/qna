require 'rails_helper'

feature 'User can sign out', %q{
  In order to end the session
  I`d like to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authorized user logs out' do
    sign_in(user)

    visit root_path
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end
