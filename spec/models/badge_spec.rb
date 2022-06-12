require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional }

  it { should have_db_column(:question_id) }
  it { should have_db_index(:question_id) }

  it { should have_db_column(:user_id) }
  it { should have_db_index(:user_id) }

  it { should validate_length_of(:name).is_at_least(5) }
  it { should validate_presence_of(:name) }

  it 'have attached image' do
    expect(Badge.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
