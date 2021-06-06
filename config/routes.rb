Rails.application.routes.draw do
  get 'games/index'
  root to: 'games#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    delete "/users/sign_out" => "devise/sessions#destroy"
  end
end
