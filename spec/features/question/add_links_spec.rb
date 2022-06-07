require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to ba able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/galuropek/c324f0d28418078cae9aa4363e2dcf16' }

  scenario 'User adds link when asks question' do
    sign_in user
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
