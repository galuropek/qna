require 'rails_helper'

feature 'User can answer to the question', %q{
  User can answer to the question from the answer`s page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers to the question from the question`s page' do
      fill_in 'Title', with: answer.title
      fill_in 'Body', with: answer.body
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
    end

    scenario 'answers to the question with error' do
      click_on 'Answer'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user answers to the questions' do
    visit question_path(question)
    fill_in 'Title', with: answer.title
    fill_in 'Body', with: answer.body
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
