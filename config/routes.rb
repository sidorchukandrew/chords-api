Rails.application.routes.draw do
  get '/themes', to: 'themes#index'
  post '/themes', to: 'themes#create'
  resources :songs do
    post "/themes", to: "songs#add_themes"
    delete "/themes", to: "songs#remove_themes"
  end
  resources :binders do
    post "/songs", to: "binders#add_songs"
    delete "/songs", to: "binders#remove_songs"
  end
  resources :teams
  mount_devise_token_auth_for 'User', at: 'auth'
end
