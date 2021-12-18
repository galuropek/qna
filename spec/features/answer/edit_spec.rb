require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can`t edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'edit answer'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with error'
    scenario 'tries to edit othe user`s answer'
  end
end
