Rails.application.routes.draw do
  
  # mount ActionCable.server => '/cable'
  root "static_pages#login_index"

  # API関連
  namespace :api do
    namespace :v1 do
      post "sign_in", to: "sessions#create"

      # 管理者が自身のアカウントを更新
      namespace :admins do
        namespace :registrations do
          post "update_self"
        end
      end

      # マネージャーが自身のアカウントを更新
      namespace :managers do
        namespace :registrations do
          post "update_self"
        end
      end

      # スタッフが自身のアカウントを更新
      namespace :staffs do
        namespace :registrations do
          post "update_self"
        end
      end

      # 従業員が行う操作
      namespace :employees do
        # スタッフCRUD
        post "index_managers", to: "managers#index"
        post "show_manager", to: "managers#show"
        post "create_manager", to: "managers#create"
        post "update_manager", to: "managers#update"
        post "destroy_manager", to: "managers#destroy"

        # スタッフCRUD
        post "index_staffs", to: "staffs#index"
        post "show_staff", to: "staffs#show"
        post "create_staff", to: "staffs#create"
        post "update_staff", to: "staffs#update"
        post "destroy_staff", to: "staffs#destroy"

        # 顧客CRUD
        post "index_clients", to: "clients#index"
        post "create_client", to: "clients#create"
        post "update_client", to: "clients#update"
        post "destroy_client", to: "clients#destroy"

        # 外注先CRUD
        post "index_suppliers", to: "suppliers#index"
        post "create_supplier", to: "suppliers#create"
        post "update_supplier", to: "suppliers#update"
        post "destroy_supplier", to: "suppliers#destroy"

        # 案件CRUD
        post "create_matter", to: "matters#create"
        post "update_matter", to: "matters#update"
        post "destroy_matter", to: "matters#destroy"

        namespace :settings do
          # 業種CRUD
          post "index_industries", to: "industries#index"
          post "create_industry", to: "industries#create"
          post "update_industry", to: "industries#update"
          post "destroy_industry", to: "industries#destroy"

          # デフォルトタスクCRUD
          post "create_task", to: "tasks#create"
          post "update_task", to: "tasks#update"
          post "destroy_task", to: "tasks#destroy"
        end
        
        # 外部スタッフCRUD
        post "create_external_staff", to: "external_staffs#create"
        post "update_external_staff", to: "external_staffs#update"

        # 従業員自身の勤怠関連
        post "index_attendances", to: "attendances#index"
        post "register_attendance", to: "attendances#register"
      end

      # 顧客が自身のアカウントを更新
      namespace :clients do
        namespace :registrations do
          post "update_self"
        end
      end

      # 外部スタッフが自身のアカウントを更新
      namespace :external_staffs do
        namespace :registrations do
          post "update_self"
        end
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
    namespace :admins do
      get :top
      get :index
    end
  end
  
  # Manager関係
  scope module: :managers do
    namespace :managers do
      get :top
      get :index
    end
  end

  namespace :managers do
    resources :attendances, only: [:index, :update]
  end
  
  # Client関係
  scope module: :clients do
    namespace :clients do
      get :top
      get :index
    end
  end

  namespace :clients do
    resources :matters, only: [:index, :show]
  end

  # Staff関係
  scope module: :staffs do
    namespace :staffs do
      get :top
      get :index
    end
  end

  namespace :staffs do
    resources :attendances, only: [:index, :update] do
      get :change_month, on: :collection
    end
  end

  # ExternalStaff関係
  scope module: :external_staffs do
    namespace :external_staffs do
      get :top
      get :index
    end
  end

  namespace :external_staffs do
    resources :attendances, only: [:index, :update] do
      get :change_month, on: :collection
    end
  end

  # 従業員が行う操作
  namespace :employees do
    resources :managers
    resources :staffs
    resources :clients
    resources :suppliers do
      resources :external_staffs, only: [:new, :create, :show, :edit, :update, :destroy]
    end
    resources :attendances, only: [:new, :create, :update, :destroy] do
      collection do
        get :daily
        get :individual
      end
    end

    resources :estimate_matters do
      resources :matters, only: :create
      resources :tasks, only: [:edit, :update, :destroy], controller: "estimate_matters/tasks" do
        post :move, on: :collection
        post :create, on: :collection
      end
      resources :talkrooms, only: [:index, :create] do
        get :scroll_get_messages, on: :collection
      end
      resources :estimates, only: [:new, :create, :index, :edit, :update, :destroy], controller: "estimate_matters/estimates" do
        post :copy, on: :member
      end
      resources :images, controller: "estimate_matters/images"
      resources :categories, only: [:edit, :update, :destroy], controller: "estimate_matters/categories"
      resources :materials, only: [:edit, :update, :destroy], controller: "estimate_matters/materials"
      resources :constructions, only: [:edit, :update, :destroy], controller: "estimate_matters/constructions"
    end

    resources :matters, only: [:show, :edit, :update, :destroy, :index] do
      resources :tasks, only: [:edit, :update, :destroy], controller: "matters/tasks" do
        post :move, on: :collection
        post :create, on: :collection
      end
      resources :images, controller: "matters/images"
      resources :talkrooms, only: [:index, :create] do
        get :scroll_get_messages, on: :collection
      end
    end
    
    namespace :settings do
      resources :industries, only: [:new, :create, :index, :edit, :update, :destroy]
      resources :departments, only: [:new, :create, :index, :edit, :update, :destroy]
      resources :tasks, only: [:create, :new, :edit, :index, :update, :destroy]
      resources :categories, only: [:create, :new, :edit, :index, :update, :destroy]
      resources :kinds, only: [:create, :new, :edit, :index, :update, :destroy]
      resources :materials, only: [:create, :new, :edit, :index, :update, :destroy]
      resources :constructions, only: [:create, :new, :edit, :index, :update, :destroy]
    end
  end
end
