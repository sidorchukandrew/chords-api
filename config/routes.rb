Rails.application.routes.draw do
  resources :songs
  resources :binders do
    post "/songs", to: "binders#add_songs"
    delete "/songs", to: "binders#remove_songs"
  end
  resources :teams
  mount_devise_token_auth_for 'User', at: 'auth'
end
