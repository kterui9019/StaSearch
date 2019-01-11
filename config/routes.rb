Rails.application.routes.draw do
  #get 'reviews/new'
  #get 'sessions/new'
  root 'static_pages#home'
  get '/login',     to: "sessions#new"
  post 'login',     to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  get 'search',     to: 'studios#search'
  resources :studios
  resources :users
  resources :favorites, only:[:create, :destroy]
  resources :reviews, only:[:new, :create, :destroy]
end