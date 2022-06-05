require 'rails_helper'

feature 'User can remove question', %q{
  Only the author can remove him question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user (author)' do
    given(:other_user) { create(:user) }
    given(:other_question) { create(:question, user: other_user) }

    background { sign_in(user) }

    scenario 'removes his question' do
      visit question_path(question)
      click_on 'remove question'

      expect(page).to have_content 'Question successfully removed.'
    end

    scenario 'removes someone else`s question' do
      visit question_path(other_question)

      expect(page).to have_no_link 'Remove Question'
    end

    scenario 'removes attached file' do
      attach_file_to(question)
      visit question_path(question)

      within '.attachments' do
        find('.attachment', text: 'rails_helper.rb').find('.remove-attachment').click
      end

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  scenario 'Unautheticated user removes a question' do
    visit question_path(question)

    expect(page).to have_no_link 'Remove Question'
  end
end
