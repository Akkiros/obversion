Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get '/accounts/' => 'accounts#index'
  get '/accounts/new' => 'accounts#new'
  post '/accounts/create' => 'accounts#create'
  post '/accounts/login' => 'accounts#login'
  get '/accounts/logout' => 'accounts#logout'

  get '/games/' => 'games#index'
  get '/games/new' => 'games#new'
  post '/games/create' => 'games#create'
  post '/games/join' => 'games#join'
  post '/games/leave' => 'games#leave'
  get '/games/show' => 'games#show'
  post '/games/start' => 'games#start'
  post '/games/click' => 'games#click'
end
