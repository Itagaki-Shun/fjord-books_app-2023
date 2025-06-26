Rails.application.routes.draw do
  get 'users/show'
  get 'users/index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :books
  resources :users, only: [:show, :index]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
