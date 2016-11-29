Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :bucket_lists, only: [:index, :show, :create, :update, :destroy], path: :bucketlists do
        resources :bucket_list_items, only: [:index, :show, :create, :update, :destroy], path: :items
      end

      post "auth/login", to: "authentications#login"
      get "auth/logout", to: "authentications#logout"
    end
  end
end
