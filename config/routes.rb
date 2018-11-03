Rails.application.routes.draw do
  get 'users/show'
  devise_for :users, path: '', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }
  root to: 'users#dashboard'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/dashboard', to: 'users#dashboard'
  patch '/wait_list', to: 'users#wait_list'
  patch '/add_student', to: 'users#add_student'
end
