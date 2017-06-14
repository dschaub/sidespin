Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'user_sessions#new', as: :new_user_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :challenges
  resources :games
  resource :dashboard

  root to: redirect('/dashboard')
end
