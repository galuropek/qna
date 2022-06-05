Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    member do
      delete :destroy_attachment
    end

    resources :answers, shallow: true do
      member do
        post :best
      end
    end
  end
end
