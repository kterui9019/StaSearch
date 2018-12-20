Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get '/login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  resources :studios
  resources :users
end
