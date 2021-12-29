require 'rails_helper'

feature 'User can remove answer', %q{
  Only the author can remove him answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    given(:other_user) { create(:user) }
    given(:other_answer) { create(:answer, question: question, user: other_user) }

    background { sign_in(user) }

    scenario 'removes his answer' do
      visit question_path(answer.question)
      click_on 'remove answer'

      within '.answers' do
        expect(page).to_not have_content answer.body
      end
    end

    scenario 'removes someone else`s answer' do
      visit question_path(other_answer.question)

      expect(page).to have_no_link 'remove answer'
    end
  end

  describe 'Unautheticated user' do
    scenario 'removes a answer' do
      visit question_path(answer.question)

      expect(page).to have_no_link 'remove answer'
    end
  end
end

