require 'rails_helper'

feature 'User can view a questions list' do
  given!(:questions) { create_list(:question, 2) }

  scenario 'User views a questions list' do
    visit questions_path

    expect(page).to have_content 'Questions list:'
    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
  end
end
