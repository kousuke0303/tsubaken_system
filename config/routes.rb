Rails.application.routes.draw do
  root "static_pages#login_index"
  
  # Adminログイン関係
  devise_for :admins, controllers: {
    sessions:      "admins/sessions",
    passwords:     "admins/passwords",
    registrations: "admins/registrations"
  }

  # Managerログイン関係
  devise_for :managers, controllers: {
    sessions:      "managers/sessions",
    passwords:     "managers/passwords",
    registrations: "managers/registrations"
  }

  # Staffログイン関係
  devise_for :staffs, controllers: {
    sessions:      "staffs/sessions",
    passwords:     "staffs/passwords",
    registrations: "staffs/registrations"
  }

  scope module: :admins do
    resources :admins, only: [:show] do
      get :top, on: :member
      resources :managers
    end
  end
  
  # ###--MANAGER:CONTROLLER--###############################
  
  scope module: :managers do
    resources :managers, only: [:index] do
      get :top, on: :member
      get :employee, on: :member
      get :employee_type, on: :member
      get :enduser, on: :member
    # staff CRUD
      resources :staffs, path: '/employee/staffs' do
        delete :outsourcing_staff_destroy, on: :member
      end
    # user CRUD
      resources :users, path: '/enduser/users'
    # suppliers
      resources :suppliers
    end
  end
    
  # ###--STAFF:CONTROLLER--################################
  
  scope module: :staffs do
    resources :staffs, only: [:show, :edit, :update] do
      get :top, on: :member
      # matter
      resources :matters, only: [:index, :show] do
        get :move_task, on: :member
      end
      # event
      resources :events, only: [:index]
      namespace :settings do
        resources :staff_events
        resources :staff_event_titles, except: [:index]
      end
    end
  end
  
  # ###--MATTER関連--################################
  
  # scope "(:manager_public_uid)" do
  #   namespace :matter do
  #     resources :matters, path: '/', only: [:new, :index, :show] do
  #       patch :title_update, on: :member
  #       patch :client_update, on: :member
  #       patch :person_in_charge_update, on: :member
  #       patch :update_manage_authority, on: :member
  #       get :selected_user, on: :collection
  #       post :connected_matter 
  #       # matter関連タスク
  #       resources :matter_tasks, only: [:update, :destroy] do
  #         get :create, on: :collection
  #         get :move_task, on: :collection
  #       end
  #     end
  #   end
  # end
  
  # ###--EVENT関連--################################
  
  scope "(:manager_public_uid)" do
    namespace :manager do
      resources :events, only: [:index] 
    end
  end
  
  # ###--SETTING--##################################
  
  scope "(:manager_public_uid)" do
    namespace :manager do
      namespace :settings do
        resources :tasks, except: [:index]
        resources :manager_events
        resources :manager_event_titles, except: [:index]
      end
    end
  end
  
  # ###--API_RECIEVE_ADRESS-##########################
  
  scope "(:manager_public_uid)" do
    get 'prefecture_index', to: 'addresses#prefecture_index'
    get 'city_index', to: 'addresses#city_index'
    get 'town_index', to: 'addresses#town_index'
    get 'block_index', to: 'addresses#block_index'
    get 'selected_block', to: 'addresses#selected_block'
  end
end
