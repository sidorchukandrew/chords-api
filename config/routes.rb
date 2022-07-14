Rails.application.routes.draw do

  # setlists
  resources :setlists do
    # setlist's specific songs
    post '/songs', to: 'setlists#add_songs'
    delete '/songs', to: 'setlists#remove_songs'
    put '/songs/:song_id', to: 'setlists#update_scheduled_song'

    # sessions
    post '/sessions', to: 'sessions#create'
    get '/sessions', to: 'sessions#index'
    put "/sessions/:id", to: 'sessions#update'
  end

  # invitations
  resources :invitations do
    post '/resend', to: 'invitations#resend'
  end

  post 'invitations/claim', to: 'invitations#claim'
  post 'invitations/signup', to: 'invitations#signup_through_invitation'

  # themes
  get '/themes', to: 'themes#index'
  post '/themes', to: 'themes#create'

  # genres
  get '/genres', to: 'genres#index'

  # songs
  resources :songs do
    # song's specific themes
    post '/themes', to: 'songs#add_themes'
    delete '/themes', to: 'songs#remove_themes'

    # song's specific genres
    post '/genres', to: 'songs#add_genres'
    delete '/genres', to: 'songs#remove_genres'

    get '/formats', to: 'formats#index'

    # notes
    resources :notes

    # files
    post '/files', to: 'files#attach_to_song'
    get '/files', to: 'files#index_song_files'
    delete '/files/:id', to: 'files#delete_song_file'
    put '/files/:id', to: 'files#update_song_file'

    # capos
    post '/capos', to: 'capos#create'
    delete '/capos/:id', to: 'capos#destroy'
    put '/capos/:id', to: 'capos#update'

    # tracks
    get '/tracks', to: 'tracks#index'
    post '/tracks', to: 'tracks#create_bulk'
    delete '/tracks/:id', to: 'tracks#destroy'
  end

  delete '/songs', to: 'songs#destroy_bulk'


  # formats
  put '/formats/:id', to: 'formats#update'
  post '/formats', to: 'formats#create'

  # binders
  resources :binders do

    # binder's specific songs
    post '/songs', to: 'binders#add_songs'
    delete '/songs', to: 'binders#remove_songs'
  end

  # teams
  resources :teams, param: :team_id
  get '/teams/:team_id/memberships', to: 'team_memberships#index'

  # users
  scope '/users/me' do
    resources :notification_settings, only: %i[update index]
  end

  get '/users/me', to: 'users#me'
  put '/users/me', to: 'users#update_me'

  devise_scope :user do
    delete '/users/me', to: 'devise_token_auth/registrations#destroy'
  end

  delete '/users/me/teams/:team_id', to: 'users#leave_team'
  get '/users/me/memberships', to: 'users#membership'
  get '/users/:id/memberships/:team_id', to: 'users#show_membership'
  put '/users/:id/memberships/:team_id', to: 'users#update_membership'
  delete '/users/:id/memberships/:team_id', to: 'users#remove_membership'


  # planning center
  post '/pco/auth', to: 'planning_center#auth'
  get '/pco/songs', to: 'planning_center#index'
  post '/pco/songs', to: 'planning_center#import'
  delete '/pco/users/me', to: 'planning_center#disconnect'

  # files
  post '/files/users', to: 'files#create_user_image'
  delete '/files/users', to: 'files#delete_user_image'
  post '/files/teams/:team_id', to: 'files#create_team_image'
  delete '/files/teams/:team_id', to: 'files#delete_team_image'

  # public setlists
  get '/public_setlists', to: 'public_setlists#index'
  get '/public_setlists/:id', to: 'public_setlists#show'
  post '/public_setlists', to: 'public_setlists#create'
  put '/public_setlists/:id', to: 'public_setlists#update'

  mount_devise_token_auth_for 'User', at: 'auth'

  scope '/admin' do
    scope '/users' do
      get '/', to: 'admin_users#index'
      get '/:id', to: 'admin_users#show'
      get '/:id/memberships', to: 'admin_users#memberships'
    end

    scope '/teams' do
      get '/', to: 'admin_teams#index'
      get '/:id', to: 'admin_teams#show'
      get '/:id/memberships', to: 'admin_teams#memberships'

      get '/:id/songs', to: 'admin_teams#songs'
      get '/:id/binders', to: 'admin_teams#binders'
      get '/:id/setlists', to: 'admin_teams#setlists'
    end
  end

  post '/feedback', to: 'feedback#create'

  # roles
  resources :roles
  post '/roles/:id/memberships', to: 'roles#assign_role_bulk'

  delete '/roles/:id/permissions', to: 'roles#remove_permission'
  post '/roles/:id/permissions', to: 'roles#add_permission'
  delete '/roles/:id', to: 'roles#destroy'

  # permissions
  resources :permissions, only: %i[show index]

  post '/memberships/:id/role', to: 'memberships#assign_role'

  # onsong
  scope '/onsong' do
    post 'unzip', to: 'onsong#unzip'
    post 'import/:id', to: 'onsong#import'
  end

  # stripe webhooks
  scope '/stripe/webhooks' do
    post 'trial_will_end', to: 'stripe_webhooks#trial_will_end'
    post 'subscription_updated', to: 'stripe_webhooks#subscription_updated'
    post 'subscription_cancelled', to: 'stripe_webhooks#subscription_cancelled'
  end

  # billing
  scope '/billing' do
    post 'customer_portal_sessions', to: 'customer_portal_sessions#create'
  end

  # events
  resources :events

  # dashboard
  get '/dashboard', to: "dashboard#show"

  # contact submissions
  post '/contact_submissions', to: 'contact_submissions#create'

  # imports
  post '/imports', to: 'imports#import' 

  # mobile cache
  scope '/cache' do
    get 'songs', to: 'cache#index_songs'
    get '/setlists', to: 'cache#index_setlists'
  end

  scope '/apple_music' do
    get '/search', to: 'apple_music#search'
  end

  scope '/spotify' do
    get '/search', to: 'spotify#search'
  end

  scope '/youtube' do
    get '/search', to: 'youtube#search'
  end

  get '/join/:code', to: 'join_link#find_by_join_link'
  post '/join/:code', to: 'join_link#join'
end
