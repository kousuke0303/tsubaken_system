Rails.application.routes.draw do
  root "static_pages#login_index"
  
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

  namespace :managers do
    resources :attendances, only: [:edit, :update]
  end

  # Staff関係
  scope module: :staffs do
    resources :staffs, only: [:show] do
      get :top, on: :member
    end
  end

  namespace :staffs do
    resources :attendances, only: [:edit, :update]
  end

  # ExternalStaff関係
  scope module: :external_staffs do
    resources :external_staffs, only: [:show] do
      get :top, on: :member
    end
  end

  # 従業員が行う操作
  namespace :employees do
    resources :managers
    resources :staffs
    resources :clients
    resources :suppliers
    resources :matters
    resources :external_staffs
    namespace :settings do
      resources :industries
    end
  end
  
  scope "(:manager_public_uid)" do
    get 'prefecture_index', to: 'addresses#prefecture_index'
    get 'city_index', to: 'addresses#city_index'
    get 'town_index', to: 'addresses#town_index'
    get 'block_index', to: 'addresses#block_index'
    get 'selected_block', to: 'addresses#selected_block'
  end
end
