Rails.application.routes.draw do
  root to: 'users#dashboard'

  devise_for :users, path: '', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }
  
  get '/welcome', to: 'static_pages#home', as: 'home'
  get '/about', to: 'static_pages#about'

  get '/dashboard', to: 'users#dashboard'

  patch '/wait_list', to: 'users#wait_list'
  put '/wait_list', to: 'users#wait_list'

  patch '/add_student', to: 'users#add_student'
  put '/add_student', to: 'users#add_student'

  resources :users, only: [:index, :show, :destroy]
  resources :lessons, only: [:new]

  post '/lesson', to: 'lessons#create'

  patch '/update_time_slot', to: 'time_slots#update'
  put '/update_time_slot', to: 'time_slots#update'


  get 'schedule', to: 'schedules#edit'
end
