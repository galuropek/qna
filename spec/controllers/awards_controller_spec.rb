require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:question) { create(:question) }
  let(:award) { create(:award, question: question) }
  let(:user) { create(:user, awards: [award]) }

  describe "GET index" do
    context 'when authenticated user' do
      before do
        login(user)
        get :index, params: { user_id: user }
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end

      it 'assigns awards for view' do
        expect(assigns(:awards).first).to be_eql(award)
      end
    end

    context 'Unauthenticated user' do
      it 'renders index view' do
        get :index, params: { user_id: user }
        expect(response).to_not render_template :index
      end
    end
  end
end

