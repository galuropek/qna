require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:other_user) { create(:user) }
  given(:other_answer) { create(:answer, question: question, user: user) }
  given(:google_com) { 'https://www.google.com' }

  describe 'Unauthenticated user' do
    scenario 'can`t edit answer' do
      visit question_path(question)

      expect(page).to_not have_link 'edit answer'
    end
  end

  describe 'Authenticated user (author)', js: true do
    background { sign_in user }

    scenario 'edits his answer' do
      visit question_path(question)
      click_on 'edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'edited body'
        click_on 'Save'

        check_edited_answer(answer, body: 'edited body')
      end
    end

    scenario 'edits his answer with error' do
      visit question_path(question)
      click_on 'edit answer'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'edits answer after redirect from other page' do
      visit questions_path
      all('.question-link').first.click(wait: true)
      find('.edit-answer-link').click

      within '.answers' do
        fill_in 'Your answer', with: 'edited body'
        click_on 'Save'

        check_edited_answer(answer, body: 'edited body')
      end
    end

    scenario 'adds attachments to the answer' do
      visit question_path(answer.question)

      within ".answer-id-#{answer.id}" do
        click_on 'edit answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'adds attachments to the answer when attachments already exist' do
      visit question_path(answer.question)

      within ".answer-id-#{answer.id}" do
        click_on 'edit answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      visit questions_path
      visit question_path(answer.question)

      within ".answer-id-#{answer.id}" do
        click_on 'edit answer'
        attach_file 'File', ["#{Rails.root}/config/routes.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'routes.rb'
        expect(answer.files.count).to eq(3)
      end
    end

    scenario 'adds link to the answer', js: true do
      visit question_path(answer.question)

      within ".answer-id-#{answer.id}" do
        click_on 'edit answer'
        click_on 'add link'

        fill_in 'Link name', with: 'Google COM'
        fill_in 'Url', with: google_com

        click_on 'Save'

        expect(page).to have_link 'Google COM', href: google_com
      end
    end
  end

  describe 'Other user (not author)' do
    scenario 'tries to edit someone else`s answer' do
      sign_in other_user
      visit question_path(question)

      expect(page).to_not have_link 'edit answer'
    end
  end
end
