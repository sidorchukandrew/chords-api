Rails.application.routes.draw do

  # setlists
  resources :setlists do
    # setlist's specific songs
    post "/songs", to: "setlists#add_songs"
    delete "/songs", to: "setlists#remove_songs"
    put "/songs/:song_id", to: "setlists#update_scheduled_song"
  end

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

    get "/formats", to: "formats#index"
  end
  
  # formats
  put "/formats/:id", to: "formats#update"
  post "/formats", to: "formats#create"

  
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
  get "/users/me/memberships", to: "users#membership"
  get "/users/:id/memberships/:team_id", to: "users#show_membership"
  put "/users/:id/memberships/:team_id", to: "users#update_membership"
  delete "/users/:id/memberships/:team_id", to: "users#remove_membership"

  # planning center
  post "/pco/auth", to: "planning_center#auth"
  get "/pco/songs", to: "planning_center#index"
  post "/pco/songs", to: "planning_center#import"
  delete "/pco/users/me", to: "planning_center#disconnect"

  # files
  post "/files/users", to: "files#create_user_image"
  delete "/files/users", to: "files#delete_user_image"
  post "/files/teams/:team_id", to: "files#create_team_image"
  delete "/files/teams/:team_id", to: "files#delete_team_image"

  # public setlists
  get "/public_setlists", to: "public_setlists#index"
  get "/public_setlists/:id", to: "public_setlists#show"
  
  mount_devise_token_auth_for 'User', at: 'auth'
end
