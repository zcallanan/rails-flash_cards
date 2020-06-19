Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' } # custom devise registration
  root to: 'pages#home'
  resources :decks, only: %i[index show create update] do
    resources :collections, only: %i[show create]
    resources :deck_strings, only: %i[create update]
  end
  resources :user_groups, only: %i[index show create update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
