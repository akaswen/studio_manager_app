Rails.application.routes.draw do
  devise_for :users, path: '', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }
  root to: 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
end
