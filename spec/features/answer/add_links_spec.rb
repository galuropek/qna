require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my question
  As an answer's author
  I'd like to ba able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/galuropek/c324f0d28418078cae9aa4363e2dcf16' }

  scenario 'User adds link when answer the question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
