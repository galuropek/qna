require 'rails_helper'

feature 'User can create question' do
  scenario 'User asks a question' do
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Question body'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Question body'
  end

  scenario 'User asks a question with error' do
    visit questions_path
    click_on 'Ask question'

    click_on 'Ask'

    expect(page).to have_content "Title can't be blank"
  end
end