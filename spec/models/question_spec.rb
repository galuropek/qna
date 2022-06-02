require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_db_column(:user_id) }
  it { should have_db_index(:user_id) }

  it { should have_many(:answers).dependent(:destroy) }

  it { should belong_to(:best_answer).optional }
  it { should have_db_column(:best_answer_id) }
  it { should have_db_index(:best_answer_id) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:body).is_at_least(5) }
end
