Rails.application.routes.draw do
  devise_for :users

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA support
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Main route
  root "trips#index"

  resources :trips do
    get "expense_breakdown", on: :member
    resources :expenses, only: [ :new, :create, :edit, :update, :destroy ]
  end
end
