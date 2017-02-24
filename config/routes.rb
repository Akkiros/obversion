Rails.application.routes.draw do
  get '/accounts/' => 'accounts#index'
  get '/accounts/new' => 'accounts#new'
  post '/accounts/create' => 'accounts#create'
  post '/accounts/login' => 'accounts#login'
  get '/accounts/logout' => 'accounts#new'
end
