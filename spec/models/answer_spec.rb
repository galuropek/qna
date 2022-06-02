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

  describe 'Answer' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:other_user) { create(:user) }
    let(:other_answer) { create(:answer, user: other_user) }
    let!(:question) { create(:question,
                            user: user,
                            answers: [answer, other_answer],
                            best_answer: answer) }

    context 'is best' do
      it { expect(answer.best?).to be true }
    end

    context 'is not best' do
      it { expect(other_answer.best?).to_not be true }
    end
  end
end
