require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my question
  As an answer's author
  I'd like to ba able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/galuropek/c324f0d28418078cae9aa4363e2dcf16' }
  given(:google_ru) { 'https://www.google.ru' }
  given(:google_com) { 'https://www.google.com' }
  given(:incorrect_url) { 'foobar' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User can\'t add link with incorrect url when answer the question', js: true do
    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'New link'
    fill_in 'Url', with: incorrect_url

    click_on 'Answer'

    within '.answer-errors' do
      expect(page).to have_content 'Links url is not an URL'
    end
  end

  scenario 'User adds link when answer the question', js: true do
    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'User adds several extra links when answer the question', js: true do
    fill_in 'Body', with: 'My answer'

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

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Google RU', href: google_ru
      expect(page).to have_link 'Google COM', href: google_com
    end
  end
end
