Rails.application.routes.draw do
  root "static_pages#login_index"

  namespace :api do
    namespace :v1 do
      post "sign_in", to: "sessions#create"
    end
  end
  
  # deviseのAdminログイン関係
  devise_for :admins, controllers: {
    sessions:      "admins/sessions",
    passwords:     "admins/passwords",
    registrations: "admins/registrations"
  }

  # deviseのManagerログイン関係
  devise_for :managers, controllers: {
    sessions:      "managers/sessions",
    passwords:     "managers/passwords",
    registrations: "managers/registrations"
  }

  # deviseのStaffログイン関係
  devise_for :staffs, controllers: {
    sessions:      "staffs/sessions",
    passwords:     "staffs/passwords",
    registrations: "staffs/registrations"
  }

  # deviseのClientログイン関係
  devise_for :clients, controllers: {
    sessions:      "clients/sessions",
    passwords:     "clients/passwords",
    registrations: "clients/registrations"
  }

  # deviseのExternalStaffログイン関係
  devise_for :external_staffs, controllers: {
    sessions:      "external_staffs/sessions",
    passwords:     "external_staffs/passwords",
    registrations: "external_staffs/registrations"
  }

  # Admin関係
  scope module: :admins do
    resources :admins, only: [:show] do
      get :top, on: :member
    end
  end
  
  # Manager関係
  scope module: :managers do
    resources :managers, only: [:index] do
      get :top, on: :member
    end
  end
  
  # Client関係
  scope module: :clients do
    resources :clients, only: [:index] do
      get :top, on: :member
    end
  end

  namespace :managers do
    resources :attendances, only: [:index, :update]
  end

  # Staff関係
  scope module: :staffs do
    resources :staffs, only: [:index] do
      get :top, on: :member
    end
  end

  namespace :staffs do
    resources :attendances, only: [:index, :update]
  end

  # ExternalStaff関係
  scope module: :external_staffs do
    resources :external_staffs, only: [:index] do
      get :top, on: :member
    end
  end

  namespace :external_staffs do
    resources :attendances, only: [:index, :update]
  end

  # 従業員が行う操作
  namespace :employees do
    resources :managers
    resources :staffs
    resources :clients
    resources :suppliers do
      resources :external_staffs, only: [:create, :show, :update, :destroy]
    end
    resources :attendances, only: [:update] do
      collection do
        get :daily
        get :individual
      end
    end
    resources :matters do
      resources :tasks do
        get :move_task, on: :collection
        get :create, on: :collection
      end
    end
    namespace :settings do
      resources :industries, only: [:create, :index, :update, :destroy]
    end
  end
  
  scope "(:manager_public_uid)" do
    get 'prefecture_index', to: 'addresses#prefecture_index'
    get 'city_index', to: 'addresses#city_index'
    get 'town_index', to: 'addresses#town_index'
    get 'block_index', to: 'addresses#block_index'
    get 'selected_block', to: 'addresses#selected_block'
  end
  
  namespace :employees do
    resources :tasks, only: [:update, :destroy] do
      get :create, on: :collection
      get :move_task, on: :member
    end
  end
end
