require 'rails_helper'

feature 'User can remove links from answer', %q{
  In order to edit my answer and remove extra info
  As an answer's author
  I'd like to ba able to remove links
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:answer) { create(:answer, :with_link, user: user) }
  given(:question) { create(:question, user: user, answers: [answer]) }

  scenario 'Author of answer removes link', js: true do
    sign_in(user)
    visit question_path(question)

    within('.answers') do
      expect(page).to have_link(href: answer.links.first.url)
      click_on 'remove link'
      expect(page).to_not have_link(href: answer.links.first.url)
    end
  end

  scenario 'Other user don\'t see \'remove link\'' do
    sign_in(other_user)
    visit question_path(question)

    within('.answers') do
      expect(page).to have_link(href: answer.links.first.url)
      expect(page).to_not have_link 'remove link'
    end
  end
end
