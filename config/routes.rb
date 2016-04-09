Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  root "home#index"

  namespace :api, defaults: {format: "json"} do
    namespace :v1 do
      get "login", to: "login#create"

      resources :users, only: [:show, :update]
      resources :sports, only: :index

      resources :groups, except: [:new, :edit] do
        resource :activity, except: [:new, :edit] do
          get "participants"
          get "join"
          get "unjoin"
        end

        resources :performed_activities, only: :index

        get "my", on: :collection
        member do
          get "admins"
          get "members"
          get "join"
          get "unjoin"
        end
      end
    end
  end

end
