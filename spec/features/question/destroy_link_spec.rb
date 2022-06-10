require 'rails_helper'

feature 'User can remove links from question', %q{
  In order to edit my question and remove extra info
  As an question's author
  I'd like to ba able to remove links
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, :with_link, user: user) }

  scenario 'Author of question removes link', js: true do
    sign_in(user)
    visit question_path(question)

    within('.question-container') do
      expect(page).to have_link(href: question.links.first.url)
      click_on 'remove link'
      expect(page).to_not have_link(href: question.links.first.url)
    end
  end

  scenario 'Other user don\'t see \'remove link\'' do
    sign_in(other_user)
    visit question_path(question)

    within('.question-container') do
      expect(page).to have_link(href: question.links.first.url)
      expect(page).to_not have_link 'remove link'
    end
  end
end
