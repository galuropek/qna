Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get '/users/:user_id/awards(.:format)' => 'awards#index', as: 'user_awards'
  end

  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      member do
        post :best
      end
    end
  end

  resource :attachments, only: :destroy
  resource :links, only: :destroy
end
