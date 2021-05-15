Rails.application.routes.draw do

  # themes
  get '/themes', to: 'themes#index'
  post '/themes', to: 'themes#create'
  
  # genres
  get '/genres', to: 'genres#index'

  # songs
  resources :songs do
    
    # song's specific themes
    post "/themes", to: "songs#add_themes"
    delete "/themes", to: "songs#remove_themes"

    # song's specific genres
    post "/genres", to: "songs#add_genres"
    delete "/genres", to: "songs#remove_genres"
  end
  
  # binders
  resources :binders do

    # binder's specific songs
    post "/songs", to: "binders#add_songs"
    delete "/songs", to: "binders#remove_songs"
  end
  
  #teams
  resources :teams
  
  mount_devise_token_auth_for 'User', at: 'auth'
end
