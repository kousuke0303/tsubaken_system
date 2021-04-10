Rails.application.routes.draw do
  
  # mount ActionCable.server => '/cable'
  root "static_pages#top"
  post "sign_in", to: "static_pages#error"
  
  get "postcode_search", to: "addresses#search_postcode"
  
  resources :notifications, only: :index do
    get :schedule_index, on: :collection
    get :task_index, on: :collection
    patch :updates, on: :collection
  end
      
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
    registrations: "admins/registrations",
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
      get :default_password_user_index
      post :avator_change
      get :avator_destroy
    end
    resources :statistics, only: :index do
      get :change_span, on: :collection
    end
  end
  
  # Manager関係
  scope module: :managers do
    namespace :managers do
      get :top
      get :index
      get :default_password_user_index
      post :avator_change
      get :avator_destroy
    end
  end

  namespace :managers do
    resources :attendances, only: [:index, :update] do
      get :change_month, on: :collection
    end
  end
  
  # Client関係
  scope module: :clients do
    namespace :clients do
      get :top
      get :index
    end
  end

  namespace :clients do
    resources :estimate_matters, only: [:index, :show]
    resources :inquiries, only: [:new, :create]
  end

  # Staff関係
  scope module: :staffs do
    namespace :staffs do
      get :top
      get :index
      post :avator_change
      get :avator_destroy
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
      post :avator_change
      get :avator_destroy
    end
    
  end

  namespace :external_staffs do
    resources :attendances, only: [:index, :update] do
      get :change_month, on: :collection
    end
    resources :schedules do
      post :applicate, on: :member
    end
  end

  # 従業員が行う操作
  namespace :employees do
    resources :managers, except: :edit do
      get :retirement_process, on: :member
      patch :pass_update, on: :member
      patch :resigned_registor, on: :member
      patch :restoration, on: :member
      get :confirmation_for_destroy, on: :member
    end
    resources :staffs, except: :edit do
      get :retirement_process, on: :member
      patch :pass_update, on: :member
      patch :resigned_registor, on: :member
      patch :restoration, on: :member
      get :confirmation_for_destroy, on: :member
    end
    resources :external_staffs, except: :edit do
      get :retirement_process, on: :member
      patch :pass_update, on: :member
      patch :resigend_registor, on: :member
      patch :out_of_service, on: :member
      patch :restoration, on: :member
      get :confirmation_for_destroy, on: :member
    end
    resources :clients do
      post :search_index, on: :collection
      patch :reset_password, on: :member
    end
    resources :suppliers
    
    resources :attendances, only: [:new, :create, :edit, :update, :destroy] do
      collection do
        get :daily
        get :individual
      end
    end
    resources :schedules do
      get :change_member, on: :member
      patch :update_member, on: :member
      get :application, on: :collection
      get :application_detail, on: :member
      patch :commit_application, on: :member
    end
    resources :band_connections, only: [:index, :destroy] do
      get :connect, on: :collection
      get :get_album, on: :member
      get :reload, on: :collection
    end
    resources :estimate_matters do
      get :progress_table, on: :collection
      get :progress_table_for_six_month, on: :collection
      get :progress_table_for_three_month, on: :collection
      get :prev_progress_table, on: :collection
      get :next_progress_table, on: :collection
      get :change_member,on: :member
      patch :update_member, on: :member
      
      resources :talkrooms, only: [:index, :create] do
        get :scroll_get_messages, on: :collection
      end
      resources :estimates, only: [:new, :create, :index, :edit, :update, :destroy], controller: "estimate_matters/estimates" do
        get :change_label_color, on: :collection
        get :copy, on: :member
        post :move, on: :member
      end
      resources :estimate_details, only: [:edit, :update, :destroy], controller: "estimate_matters/estimate_details" do
        get :detail_object_edit, on: :member
        patch :detail_object_update, on: :member
      end
      resources :images, controller: "estimate_matters/images" do
        post :save_for_band_image, on: :collection
      end
      resources :messages, only: [:index], controller: "estimate_matters/messages"
      resources :sales_statuses, only: [:new, :create, :edit, :update, :destroy], controller: "estimate_matters/sales_statuses"
      resources :certificates, controller: "estimate_matters/certificates" do
        get :select_title, on: :collection
        patch :sort, on: :collection
        get :preview, on: :collection
      end
      resources :covers, except: [:index]
    end
    
    scope module: :estimate_matters do
      resources :current_situations, only: :index do
        get :move_span, on: :collection
        get :change_span, on: :collection
      end
    end
    

    resources :matters do
      patch :change_estimate, on: :member
      get :change_member,on: :member
      patch :update_member, on: :member
      resources :invoices, only: [:show, :edit, :update], controller: "matters/invoices"
      resources :invoice_details, only: [:edit, :update, :destroy], controller: "matters/invoice_details" do
        get :detail_object_edit, on: :member
        patch :detail_object_update, on: :member
      end
      resources :tasks, only: [:edit, :update, :destroy], controller: "matters/tasks" do
        post :move, on: :collection
        post :create, on: :collection
        get :change_member, on: :member
        patch :update_member, on: :member
      end
      resources :images, controller: "matters/images" do
        post :save_for_band_image, on: :collection
      end
      resources :reports, only: [:index, :create, :new, :edit, :update, :destroy], controller: "matters/reports" do
        patch :sort, on: :collection
      end
      resources :report_covers, only: [:create, :new, :edit, :update, :destroy], controller: "matters/report_covers"
      resources :messages, only: [:index], controller: "matters/messages"
      resources :talkrooms, only: [:index, :create] do
        get :scroll_get_messages, on: :collection
      end
    end

    resources :inquiries, only: [:index, :show, :edit, :update, :destroy]
    
    namespace :settings do
      resources :companies, only: :index
      namespace :companies do
        resources :publishers, except: :index do
          patch :sort, on: :collection
          post :image_change, on: :member
          patch :image_delete, on: :member
        end
        resources :departments, only: [:create, :edit, :update, :destroy] do
          patch :sort, on: :collection
        end
        resources :attract_methods, only: [:create, :edit, :update, :destroy] do
          patch :sort, on: :collection
        end
        resources :industries, only: [:create, :edit, :update, :destroy] do
          patch :sort, on: :collection
        end
      end
      
      resources :estimates, only: :index do
        get :search_category, on: :collection
        get :search_construction, on: :collection
        get :search_material, on: :collection
      end
      namespace :estimates do
        resources :plan_names, except: :index do
          patch :sort, on: :collection
        end
        resources :materials
        resources :constructions
        resources :categories, except: :index do
          patch :sort, on: :collection
        end
      end
      
      resources :others, only: :index do
      end
      namespace :others do
        resources :label_colors, except: :index do
          patch :sort, on: :collection
        end
      end
      
      resources :tasks, only: [:create, :new, :edit, :index, :update, :destroy] do
        patch :sort, on: :collection
      end
      resources :certificates, only: [:create, :new, :edit, :index, :update, :destroy]
      resources :covers, only: [:create, :new, :edit, :update, :destroy]
      
    end
  end
end
