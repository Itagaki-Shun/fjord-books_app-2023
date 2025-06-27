Rails.application.routes.draw do
  get 'mypage', to: 'users#mypage'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  mount LetterOpenerWeb::Engine, at: '/letter_opener'
  resources :books
  resources :users, only: [:index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
