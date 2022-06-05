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

  def attach_file_to(source)
    source.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                        filename: 'rails_helper.rb', content_type: 'text/plain')
  end
end
