require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to ba able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/galuropek/c324f0d28418078cae9aa4363e2dcf16' }
  given(:google_ru) { 'https://www.google.ru' }
  given(:google_com) { 'https://www.google.com' }
  given(:incorrect_url) { 'foobar' }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User can\'t add link with invalid url when asks question' do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'New link'
    fill_in 'Url', with: incorrect_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is not an URL'
  end

  scenario 'User adds link when asks question', js: true do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds several extra links when asks question', js: true do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    within(all('.nested-fields').last) do
      fill_in 'Link name', with: 'Google RU'
      fill_in 'Url', with: google_ru
    end

    click_on 'add link'

    within(all('.nested-fields').last) do
      fill_in 'Link name', with: 'Google COM'
      fill_in 'Url', with: google_com
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'Google RU', href: google_ru
    expect(page).to have_link 'Google COM', href: google_com
  end
end
