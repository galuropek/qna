module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def check_edited_answer(answer, updated_attrs)
    expect(page).to_not have_content answer.body
    expect(page).to have_content updated_attrs[:body]
    expect(page).to_not have_selector 'textarea'
  end

  def check_edited_question(question, updated_attrs)
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(page).to have_content updated_attrs[:title]
    expect(page).to have_content updated_attrs[:body]
    expect(page).to_not have_selector 'textarea'
  end
end
