require 'rails_helper'

feature 'User can view question and answers', %q{
  User goes to the question page
  View question's attributes and answers of this question
} do

  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  background { visit question_path(question) }

  scenario "User views question's attributes" do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario "User views answer no the question's page" do
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
