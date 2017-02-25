Rails.application.routes.draw do
  get '/accounts/' => 'accounts#index'
  get '/accounts/new' => 'accounts#new'
  post '/accounts/create' => 'accounts#create'
  post '/accounts/login' => 'accounts#login'
  get '/accounts/logout' => 'accounts#new'

  get '/games/' => 'games#index'
  get '/games/new' => 'games#new'
  post '/games/create' => 'games#create'
  post '/games/join' => 'games#join'
  get '/games/show' => 'games#show'
  post '/games/start' => 'games#start'
end
