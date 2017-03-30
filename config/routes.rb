Rails.application.routes.draw do
  root 'pages#home'
  resources :contacts
  get 'signup', to: 'users#new'
  resources :users, except: [:new]
  resources :friendships
  
   get 'login', to: 'sessions#new'
  
  post 'login', to: 'sessions#create'
  
  delete 'logout', to: 'sessions#destroy'
  
  get 'my_friends', to: 'users#my_friends'
  
  get 'search_friends', to: 'users#search'
  post 'add_friend', to: 'users#add_friend'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
