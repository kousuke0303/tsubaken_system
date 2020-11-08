Rails.application.routes.draw do
  root "static_pages#login_index"

  # API関連
  namespace :api do
    namespace :v1 do
      post "sign_in", to: "sessions#create"

      # 管理者Update
      namespace :admins do
        namespace :registrations do
          post "self_update", to: "self_update"
        end
      end

      # 従業員が行う操作
      namespace :employees do
        # スタッフCRUD
        post "create_staff", to: "staffs#create"
        post "update_staff", to: "staffs#update"
        post "destroy_staff", to: "staffs#destroy"

        # 顧客CRUD
        post "create_client", to: "clients#create"
        post "update_client", to: "clients#update"
        post "destroy_client", to: "clients#destroy"

        # 外注先CRUD
        post "create_supplier", to: "suppliers#create"
        post "update_supplier", to: "suppliers#update"
        post "destroy_supplier", to: "suppliers#destroy"
        
        namespace :settings do
          # 業種CRUD
          post "create_industry", to: "industries#create"
          post "update_industry", to: "industries#update"
          post "destroy_industry", to: "industries#destroy"
        end
        
        # 外部スタッフCRUD
        post "create_external_staff", to: "external_staffs#create"
        post "update_external_staff", to: "external_staffs#update"
        post "destroy_external_staff", to: "external_staffs#destroy"

        # 従業員自身の勤怠関連
        post "index_attendances", to: "attendances#index"
        post "register_attendance", to: "attendances#register"
      end
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

  namespace :managers do
    resources :attendances, only: [:index, :update]
  end
  
  # Client関係
  scope module: :clients do
    resources :clients, only: [:index] do
      get :top, on: :member
    end
  end

  namespace :clients do
    resources :matters, only: [:index, :show]
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
    resources :attendances, only: [:create, :update, :destroy] do
      patch :erase, on: :member
      collection do
        get :daily
        get :individual
      end
    end

    resources :matters do
      resources :tasks do
        get :move_task, on: :collection
        post :create, on: :collection
      end
    end

    resources :tasks, only: [:create, :index, :update, :destroy] do
      post :create, on: :collection
      post :move, on: :member
    end
    
    namespace :settings do
      resources :industries, only: [:create, :index, :update, :destroy]
      resources :departments, only: [:create, :index, :update, :destroy]
      resources :tasks, only: [:create, :index, :update, :destroy]
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
