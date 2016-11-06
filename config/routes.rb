Rails.application.routes.draw do

  root 'profiles#index' # this is the entry point for the UI

  namespace :api do
    get '/profiles', to: 'profiles_api#index'
    post '/profiles', to: 'profiles_api#create'
  end
end
