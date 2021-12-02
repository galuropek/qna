require 'rails_helper'

feature 'User can answer to the question', %q{
  User can answer to the question from the answer`s page
} do
  given(:question) { create(:question) }

  background { visit question_path(question) }

  scenario 'User answers to the question from the question`s page' do
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'User answers to the question with error' do
    click_on 'Answer'

    expect(page).to have_content "Title can't be blank"
  end
end
