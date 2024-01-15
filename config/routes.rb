Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :games, only: %i[show create update] do
    resource :user, path: 'player1', only: %i[update]
    resource :user, path: 'player2', only: %i[update]
  end
end
