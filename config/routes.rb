Rails.application.routes.draw do
  
  #root to: 'sessions#new'

  get  '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  get  '/dropbox/authorize'   => 'users#authorize', as: :dropbox_auth
  get  '/dropbox/callback' => 'users#callback', :as =>  :dropbox_callback

  get  '/dashboard' => 'dropbox_files#view_photos_on_dashboard', as: :dashboard
  get  '/render_new_photos' => 'dropbox_files#render_new_photos'
  
  get '/observers/new' => 'observers#new', as: :observer
  post '/observers' => 'observers#create'
  
end
