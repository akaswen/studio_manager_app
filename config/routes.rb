Rails.application.routes.draw do
  devise_for :users
  root to: 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
end
