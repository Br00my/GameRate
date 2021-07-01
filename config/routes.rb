require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  scope 'games' do
    get 'index', to: 'games#index', as: :games_path
    post 'update_list', to: 'games#update_list', as: :games_update_list
  end

  root to: 'games#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    delete "/users/sign_out" => "devise/sessions#destroy"
  end
end
