require 'rails_helper'

feature 'Author of question can choose best answer', %q{
  In order to choose best answer
  As an author of question
  I'd like ot be able to mark answer as a best
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Unauthenticated user' do
    scenario 'can`t mark answer as best' do
      visit question_path(question)

      expect(page).to_not have_link 'mark as best'
    end
  end

  describe 'Authenticated user (author of question)' do
    given(:other_user) { create(:user) }
    given!(:other_answer) { create(:answer, question: question, user: other_user) }

    background { sign_in user }

    scenario 'mark answer as a best' do
      visit question_path(question)
      expect(find('.answers')).to_not have_css '.best_answer'
      within('.answers') { find(".answer-id-#{answer.id}").click_link('mark as best') }
      within('.answers') { expect(find('.best_answer')).to have_content question.answers.first.body }
    end

    scenario 'mark other answer as a best when best answer already exists' do
      visit question_path(question)
      expect(find('.answers')).to_not have_css '.best_answer'
      # mark first answer as best
      within('.answers') { find(".answer-id-#{answer.id}").click_link('mark as best') }
      within('.answers') { expect(find('.best_answer')).to have_content answer.body }
      # mark other answer as best
      within('.answers') { find(".answer-id-#{other_answer.id}").click_link('mark as best') }
      within('.answers') { expect(find('.best_answer')).to have_content other_answer.body }
    end

    scenario 'always see best answer the first' do
      visit question_path(question)
      expect(find('.answers')).to_not have_css '.best_answer'
      last_answer = question.answers.last
      # mark last answer as best
      within('.answers') { expect(all(".answer").last).to have_content last_answer.body }
      within('.answers') { all(".answer").last.click_link('mark as best') }
      # best answer exists
      within('.answers') { expect(find('.best_answer')).to have_content last_answer.body }
      # best answer is the first
      within('.answers') { expect(all(".answer").first).to have_content last_answer.body }
    end
  end
end
