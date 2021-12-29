require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to controller.question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      let(:other_user) { create(:user) }
      let!(:other_question) { create(:question, user: other_user) }

      before { login(user) }

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'edited title', body: 'edited body' } }, format: :js
        question.reload
        expect(question.title).to eq 'edited title'
        expect(question.body).to eq 'edited body'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: { title: 'edited title', body: 'edited body' } }, format: :js      
        expect(response).to render_template :update
      end

      it 'does not change question attributes with error' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          question.reload
        end.to_not change(question, :title)
      end

      it 'renders update template after trying to update attributes with error' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end

      it 'does not change someone else`s question' do
        expect do
          patch :update, params: { id: other_question, question: { title: 'edited title', body: 'edited body' } }, format: :js
          other_question.reload
        end.to_not change(other_question, :title)
      end

      it 'renders update template after trying to update someone else`s question' do
        patch :update, params: { id: other_question, question: { title: 'edited title', body: 'edited body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Unauthenticated user' do
      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: { title: 'edited title', body: 'edited body' } }, format: :js
        end.to_not change(question, :title)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    context 'authenticated user' do
      let(:other_user) { create(:user) }
      let!(:other_question) { create(:question, user: other_user) }

      before { login(user) }

      it 'removes question from db' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end

      it 'does not remove the question' do
        expect { delete :destroy, params: { id: other_question } }.to change(Question, :count).by(0)
      end

      it 'redirects to show' do
        delete :destroy, params: { id: other_question }
        expect(response).to redirect_to question_path(other_question)
      end
    end

    context 'unathenticated user' do
      it 'does not remove the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end
    end
  end
end
