Rails.application.routes.draw do
  devise_for :users
  root to: 'dashboards#show'

  resources :simple_matches, only: :create
  resource :dashboard, only: :show
end
