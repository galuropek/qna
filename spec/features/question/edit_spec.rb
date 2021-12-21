require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }

  describe 'Unauthenticated user' do
    scenario 'can`t edit question' do
      visit question_path(question)

      expect(page).to_not have_link 'edit question'
    end
  end

  describe 'Authenticated user (author)', js: true do
    background { sign_in user }

    scenario 'edits his question' do
      visit question_path(question)

      within '.question-container' do
        click_on 'edit question'

        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        check_edited_question(question, title: 'edited title', body: 'edited body')
      end
    end

    scenario 'edits his question with error' do
      visit question_path(question)
      click_on 'edit question'

      within '.question-container' do
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
      end
    end

    # tests case with turbolinks from the screencast
    scenario 'edits question after redirect from other page' do
      visit questions_path
      page.all('.question-link').first.click

      within '.question-container' do
        click_on 'edit question'

        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        check_edited_question(question, title: 'edited title', body: 'edited body')
      end
    end
  end

  describe 'Other user (not author)' do
    scenario 'tries to edit someone else`s question' do
      sign_in other_user
      visit question_path(question)

      expect(page).to_not have_link 'edit question'
    end
  end
end
