require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should have_db_column(:user_id) }
  it { should have_db_index(:user_id) }

  it { should belong_to(:question) }
  it { should have_db_column(:question_id) }
  it { should have_db_index(:question_id) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(5) }

  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  context 'of question' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:other_user) { create(:user) }
    let(:other_answer) { create(:answer, user: other_user) }
    let!(:question) { create(:question,
                             user: user,
                             answers: [answer, other_answer],
                             best_answer: answer) }

    it 'is best' do
      expect(answer.best?).to be true
    end

    it 'is not best' do
      expect(other_answer.best?).to_not be true
    end
  end
end
