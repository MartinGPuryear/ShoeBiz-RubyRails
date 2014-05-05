Shoes::Application.routes.draw do

  root  'pages#welcome' 

  get    "/welcome",     to: 'pages#welcome'
  get    "/signup",      to: 'users#new'
  get    "/signin",      to: 'sessions#new'
  delete "/signout/:id", to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :products
  post   "/buy/:id",     to: 'sales#create' 
  resources :sales

  #   get 'products/:id' => 'catalog#view'
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

end
