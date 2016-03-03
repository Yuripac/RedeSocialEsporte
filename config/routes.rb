Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  root "home#index"

  # Routes to login with a provider
  get "/auth/:provider/callback", to: "login#create", as: "auth_callback"
  # get "/auth/failure", to: "login#failure", as: "auth_failure"
  delete "/logout", to: "login#destroy", as: "logout"

  resources :groups do
    get "my", on: :collection

    member do
      get "members"
      get "join"
      get "unjoin"
    end
  end

  resources :users, only: [:show, :edit, :update, :destroy]

  #resources :sports
  #---------------API----------------------------

  namespace :api, defaults: {format: "json"} do
    namespace :v1 do
      get "login", to: "login#create"

      resources :groups, except: [:new, :edit] do
        get "my", on: :collection

        member do
          get "members"
          get "join"
          get "unjoin"
        end
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
