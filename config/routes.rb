Rails.application.routes.draw do

  # invitations
  resources :invitations do
    post "/resend", to: "invitations#resend"
  end

  post "invitations/claim", to: "invitations#claim"
  post "invitations/signup", to: "invitations#signup_through_invitation"

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
  
  # teams
  resources :teams, param: :team_id

  # users
  get "/users/me", to: "users#me"
  put "/users/me", to: "users#update_me"
  
  mount_devise_token_auth_for 'User', at: 'auth'
end
