Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'user_sessions#new', as: :new_user_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :live_games, only: [:new, :create, :update, :show] do
    collection do
      get 'current', to: 'live_games#current', as: :current_game
    end
  end

  resources :challenges do
    resource :nudge
  end

  resources :games
  resource :dashboard
  resource :me, only: [:show, :update], controller: 'me'
  resources :users, only: :show

  namespace :api do
    resource :score_button_press
    resource :rfid_tag_read, only: :create
  end

  root to: redirect('/dashboard')
end
