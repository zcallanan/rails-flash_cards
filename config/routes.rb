Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' } # custom devise registration

  root to: 'pages#home'
  resources :decks, only: %i[index show create update] do
    resources :collections, only: %i[show create] do
      resources :collection_strings, only: %i[update]
    end
      #patch 'collection_strings/:id', to: 'collection_strings#update', as: :collection_string_update
    resources :deck_strings, only: %i[create update]
  end
  resources :user_groups, only: %i[index show create update] do
    resources :memberships, only: %i[update]
  end
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :user_groups, only: [ :show ] do
        resources :memberships, only: %i[ create update ]
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
