Rails.application.routes.draw do
  resources :playlists
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/users/:uid/add_song/:did/:title/:artist/:album', to: 'users#add_song'
  get '/users/:sid/:uid', to: 'users#remove_song'
  get '/users/:uid/set_song/:did', to: 'users#set_song'

  resources :users
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end