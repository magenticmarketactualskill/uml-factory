Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  
  # Projects and Diagrams
  resources :projects do
    resources :diagrams do
      resources :diagram_elements, only: [:create, :update, :destroy]
      resources :diagram_relationships, only: [:create, :update, :destroy]
      
      member do
        get :export
        post :validate
      end
    end
  end
  
  # Admin routes
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    get 'infrastructure', to: 'dashboard#infrastructure'
    get 'users', to: 'dashboard#users'
    get 'financial', to: 'dashboard#financial'
    
    resources :users, only: [:index, :show, :edit, :update, :destroy]
  end
  
  # API endpoints for real-time updates
  namespace :api do
    namespace :v1 do
      resources :diagrams, only: [] do
        member do
          patch :update_element_position
          get :validation_status
        end
      end
    end
  end
end
