Rails.application.routes.draw do

  match '*all' => "application#cors_preflight_check", via: :options

  get "dashboard" => "manager/administrators#dashboard", as: "dashboard"

  devise_for :administrators

  devise_scope :administrator do
    root to: "devise/sessions#new"
  end  

  namespace :manager do
    resources :administrators
  end
  
  resources :vendors do
    get 'review_payment', on: :member
  end

  resources :products, except: :show
  resources :purchases, only: [:create, :index, :update, :show] do
    collection do
      get :report
    end
  end
  resources :locations, only: [:index] 
  resources :devices, only: [:create, :update, :index, :show] do
    get 'recent_vendors', on: :member
    get 'recent_transactions', on: :member
  end

  get '/.well-known/acme-challenge/:id' => 'pages#letsencrypt'
end
