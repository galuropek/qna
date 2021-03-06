require 'rails_helper'

feature 'User can create question' do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
  
      visit questions_path
      click_on 'Ask question'
    end
  
    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Question body'
      click_on 'Ask'
  
      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Question body'
    end
  
    scenario 'asks a question with error' do
      click_on 'Ask'
  
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks the question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Question body'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates question with badge' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Question body'

      fill_in 'Badge Name', with: 'Superman'
      attach_file 'Image', "#{Rails.root}/storage/images/test.jpg"

      click_on 'Ask'

      within '.badge-container' do
        expect(page).to have_content 'Superman'
        expect(find('.badge-image')['src']).to include('test.jpg')
      end
    end
  end

  scenario 'Unauthenticated user asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
