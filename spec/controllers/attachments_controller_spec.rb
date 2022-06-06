require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:answer) { create(:answer, user: user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    before { attach_file_to(answer) }
    before { attach_file_to(question) }

    context 'Authenticated user (author)' do
      before { login(user) }

      it 'removes attachment from answer' do
        expect { delete :destroy, params: { id: answer.files.first } }.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'removes attachment from question' do
        expect { delete :destroy, params: { id: question.files.first } }.to change(ActiveStorage::Attachment, :count).by(-1)
      end
    end

    context 'Other authenticated user (NOT author)' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'don\'t remove attachment from answer' do
        expect { delete :destroy, params: { id: answer.files.first } }.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'don\'t remove attachment from question' do
        expect { delete :destroy, params: { id: question.files.first } }.to_not change(ActiveStorage::Attachment, :count)
      end
    end

    context 'Unauthenticated user' do
      it 'don\'t remove attachment from answer' do
        expect { delete :destroy, params: { id: answer.files.first } }.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'don\'t remove attachment from question' do
        expect { delete :destroy, params: { id: question.files.first } }.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
