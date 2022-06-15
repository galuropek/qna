require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let!(:answer) { create(:answer, :with_link, user: user) }
  let!(:question) { create(:question, :with_link, user: user) }

  context 'Authenticated user (author)' do
    before { login(user) }

    it 'removes link from answer' do
      expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to change(Link, :count).by(-1)
    end

    it 'removes link from question' do
      expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(Link, :count).by(-1)
    end
  end

  context 'Other authenticated user (NOT author)' do
    let(:other_user) { create(:user) }

    before { login(other_user) }

    it 'don\'t remove link from answer' do
      expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to_not change(Link, :count)
    end

    it 'don\'t remove link from question' do
      expect { delete :destroy, params: { id: question.links.first }, format: :js }.to_not change(Link, :count)
    end
  end

  context 'Unauthenticated user' do
    it 'don\'t remove link from answer' do
      expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to_not change(Link, :count)
    end

    it 'don\'t remove link from question' do
      expect { delete :destroy, params: { id: question.links.first }, format: :js }.to_not change(Link, :count)
    end
  end
end
