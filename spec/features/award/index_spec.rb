require 'rails_helper'

feature 'User can view a achieved badges', %q{
  In order to see achieved badges
  As a author of best answers
  I'd like to ba able to see all my badges
} do

  given(:question_one_user) { create(:user) }
  given(:question_one) { create(:question, user: question_one_user) }
  given!(:badge_one) { create(:award, name: 'Superman', question: question_one, user: answer_author) }

  given(:question_two_user) { create(:user) }
  given(:question_two) { create(:question, user: question_two_user) }
  given!(:badge_two) { create(:award, name: 'Batman', question: question_two, user: answer_author) }

  given(:answer_author) { create(:user) }

  background { sign_in answer_author }

  scenario 'User views a achieved badges list' do
    visit user_awards_path(answer_author)

    within ".badge-id-#{badge_one.id}" do
      expect(page).to have_content question_one.title
      expect(page).to have_content 'Superman'
      expect(find('.badge-image')['src']).to include('test.jpg')
    end

    within ".badge-id-#{badge_two.id}" do
      expect(page).to have_content question_two.title
      expect(page).to have_content 'Batman'
      expect(find('.badge-image')['src']).to include('test.jpg')
    end
  end
end
