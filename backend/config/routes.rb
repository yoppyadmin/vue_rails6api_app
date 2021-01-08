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

      get '/posts', to: 'posts#index'
      get '/posts/new', to: 'posts#new'
      post '/posts', to: 'posts#create'
      get '/posts/:id', to: 'posts#show'
      # get '/posts/:id/edit', to: 'posts#edit'
      # patch '/posts/:id', to: 'posts#update'
      delete '/posts/:id', to: 'posts#destroy'

      post '/votes', to: 'votes#create'
    end
  end
end
