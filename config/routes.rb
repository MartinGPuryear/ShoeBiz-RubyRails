Shoes::Application.routes.draw do

  root  'pages#welcome' 

  get    "/welcome",        to: 'pages#welcome'
  get    "/signup",         to: 'users#new'
  get    "/signin",         to: 'sessions#new'
  delete "/signout/:id",    to: 'sessions#destroy', as: 'signout'

  resources :sessions,      only: [:new, :create, :destroy]
  resources :users
  resources :products

  resources :sales,         only: [:index, :destroy]
  post   "/sales/:id",      to: 'sales#create', as: 'create_sale'

  resources :admins,        only: [:index, :destroy]
  post   "/admins/:id",     to: 'admins#create', as: 'create_admin'

end
