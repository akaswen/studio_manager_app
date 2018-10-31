Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {sign_in: 'signin', sign_out: 'signout'}
  root to: 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
end
