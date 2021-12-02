require 'rails_helper'

feature 'User can answer to the question', %q{
  User can answer to the question from the answer`s page
} do
  given(:question) { create(:question) }

  scenario 'User answers to the question from the question`s page' do
    visit question_path(question)
    
    fill_in 'Title', with: 'Answer title'
    fill_in 'Body', with: 'Answer body'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'User answers to the question with error' do
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content "Title can't be blank"
  end
end
