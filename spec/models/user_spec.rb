require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe 'is author?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user) }

    context 'user is author of question' do
      it { expect(user.author?(question)).to be true }
    end

    context 'user is author of answer' do
      it { expect(user.author?(answer)).to be true }
    end

    context 'user is not author of question' do
      it { expect(other_user.author?(question)).to be false }
    end

    context 'user is not author of answer' do
      it { expect(other_user.author?(answer)).to be false }
    end
  end
end
