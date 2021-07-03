Rails.application.routes.draw do
  resources :games, only: %i[index show] do
    resources :reviews, only: %i[create]
  end

  post 'games/update_list', to: 'games#update_list', as: :games_update_list


  root to: 'games#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    delete "/users/sign_out" => "devise/sessions#destroy"
  end
end
