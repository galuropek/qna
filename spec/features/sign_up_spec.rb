require 'rails_helper'

feature 'User can sign up', %q{
  Guest registers in the system 
  to be able to log in and ask questions
} do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'New user registers in the system' do
    fill_in 'Email', with: 'user@mail.com'
    fill_in 'Password', with: 'test1234'
    fill_in 'Password confirmation', with: 'test1234'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User already is registered in the system' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
