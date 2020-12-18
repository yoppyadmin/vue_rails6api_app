Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      get '/users', to: 'users#index'
      get '/signup', to: 'users#new'
      post '/signup', to: 'users#create'
      get '/users/:id', to: 'users#show'
      get '/users/:id/edit', to: 'users#edit'
      patch '/users/:id', to: 'users#update'
      delete '/users/:id', to: 'users#destroy'

      get '/profile', to: 'sessions#profile'
      get '/login', to: 'sessions#new'
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
    end
  end
end
