module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def check_edited_answer(expected_body)
    expect(page).to_not have_content 'MyText'
    expect(page).to have_content expected_body
    expect(page).to_not have_selector 'textarea'
  end
end
