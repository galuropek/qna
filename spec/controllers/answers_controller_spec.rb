require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'render template create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(question.answers, :count)
      end

      it 're-renders template create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'Authenticated user' do
      let(:other_user) { create(:user) }
      let!(:other_answer) { create(:answer, user: other_user, question: question) }

      before { login(user) }

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'edited body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'edited body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: { body: 'edited body' } }, format: :js
        expect(response).to render_template :update
      end

      it 'does not change answer attributes with error' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          answer.reload
        end.to_not change(answer, :body)
      end

      it 'renders update template after trying to update attributes with error' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end

      it 'does not change someone else`s answer' do
        expect do
          patch :update, params: { id: other_answer, answer: { body: 'edited body' } }, format: :js
          other_answer.reload
        end.to_not change(other_answer, :body)
      end

      it 'renders update template after trying to update someone else`s answer' do
        patch :update, params: { id: other_answer, answer: { body: 'edited body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Unauthenticated user' do
      it 'does not change answer attribute' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'edited body' } }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'Authenticated user' do
      let(:other_user) { create(:user) }
      let!(:other_answer) { create(:answer, user: other_user, question: question) }

      before { login(user) }

      it 'removes his answer from db' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'sees render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end

      it 'does not remove someone else`s answer' do
        expect { delete :destroy, params: { id: other_answer },format: :js }.to_not change(Answer, :count)
      end

      it 'sees render destroy template after trying to remove someone else`s answer' do
        delete :destroy, params: { id: other_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Unathenticated user' do
      it 'does not remove an answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end
  end
end
