Rails.application.routes.draw do
  resources :teams
  mount_devise_token_auth_for 'User', at: 'auth'
end
