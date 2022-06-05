require 'rails_helper'

feature 'User can answer to the question', %q{
  User can answer to the question from the answer`s page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers to the question from the question`s page' do
      fill_in 'Body', with: answer.body
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content answer.body
      end
    end

    scenario 'answers to the question with error' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers to the question with attached files' do
      fill_in 'Body', with: answer.body

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user answers to the questions' do
    visit question_path(question)
    fill_in 'Body', with: answer.body
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
