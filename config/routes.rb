Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get '/users/:user_id/badges(.:format)' => 'badges#index', as: 'user_badges'
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
