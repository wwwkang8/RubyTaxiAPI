Rails.application.routes.draw do

  devise_for :users

  post 'user_token' => 'user_token#create'
  resources :bookings
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  post 'loginToken', to: 'sessions#create_token'
  post 'logoutToken', to: 'sessions#destroy_token'
  post 'bookings/finishDriving', to: 'bookings#finish_driving'
end
