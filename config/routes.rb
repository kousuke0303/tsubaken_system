Rails.application.routes.draw do
  
  # Adminログイン関係
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  
  # Managerログイン関係
  devise_for :managers, controllers: {
    sessions:      'managers/sessions',
    passwords:     'managers/passwords',
    registrations: 'managers/registrations'
  }
  
  # Submanagerログイン関係
  devise_for :submanagers, controllers: {
    sessions:      'submanagers/sessions',
    passwords:     'submanagers/passwords',
    registrations: 'submanagers/registrations'
  }

  # Staffログイン関係
  devise_for :staffs, controllers: {
    sessions:      'staffs/sessions',
    passwords:     'staffs/passwords',
    registrations: 'staffs/registrations'
  }

  # Userログイン関係
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  namespace :admin do
    resources :admins, only: [:show, :edit, :update] do
      get :top, on: :member
    end
    resources :managers, only: [:index, :destroy] do
      patch :approval, on: :member
      get :non_approval, on: :member
    end
  end
  
  # ###--MANAGER:CONTROLLER--###############################
  
  scope module: :manager do
    resources :managers, path: '/', only: [:show] do
    # manager_未承認中画面
      get :unapproval_top, on: :member, as: :manager_signup
    # 承認済開放機能  
      get :top, on: :member
      get :employee, on: :member
      get :employee_type, on: :member
      get :enduser, on: :member
    # submanager CRUD
      resources :submanagers, path: '/employee/submanagers'
    # staff CRUD
      resources :staffs, path: '/employee/staffs'
    # user CRUD
      resources :users, path: '/enduser/users'
    end
  end
  
  # ################################################################
  
  # ###--SUBMANAGER:CONTROLLER--################################
  
  scope "(:manager_public_uid)" do
    scope module: :submanager do
      resources :submanagers, only: [:show, :edit, :update] do
        get :top, on: :member
        get :enduser, on: :member
        get :employee, on: :member
        # staff CRUD
        resources :staffs, path: '/employee/staffs'
        # user CRUD
        resources :users, path: '/enduser/users'
      end
    end
  end
  
  # ################################################################

  # ###--USER:CONTROLLER--################################
  
  scope module: :user do
    resources :users, only: [:show, :edit, :update] do
      get :top, on: :member
      # matter_controller
      resources :matters, only: :show do
        post :matter_connect, on: :collection
      end
    end
  end
  
  # ################################################################
    
  # ###--STAFF:CONTROLLER--################################
  
  scope module: :staff do
    resources :staffs, only: [:show, :edit, :update] do
      get :top, on: :member
      # submanager CRUD
      resources :staffs, path: '/employee/staffs'
      # matter
      resources :matters, only: [:index, :show] do
        get :move_task, on: :member
      end
      # event
      resources :events, only: [:index]
    end
  end

  # ################################################################
  
  # ###--MATTER関連--################################
  
  scope "(:manager_public_uid)" do
    namespace :matter do
      resources :matters, path: '/' do
        patch :title_update, on: :member
        patch :client_update, on: :member
        patch :person_in_charge_update, on: :member
        patch :update_manage_authority, on: :member
        get :selected_user, on: :collection
        post :connected_matter 
        # matter関連タスク
        resources :matter_tasks, only: [:update, :destroy] do
          get :create, on: :collection
          get :move_task, on: :collection
        end
      end
    end
  end
  
  # ################################################################

  
  # ###--EVENT関連--################################
  
  scope "(:manager_public_uid)" do
    namespace :manager do
      resources :events, only: [:index] 
    end
    namespace :submanager do
      resources :events, only: [:index] 
    end
  end
  
  # ################################################################
  
  # ###--SETTING--##################################
  
  scope "(:manager_public_uid)" do
    namespace :manager do
      namespace :settings do
        resources :tasks, except: [:index]
      end
    end
    namespace :submanager do
      namespace :settings do
        resources :tasks, except: [:index]
      end
    end
  end
  
  
  # ################################################################
  
  
  root 'static_page#login_index'
  
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
