# frozen_string_literal: true

class Admins::PasswordsController < Devise::PasswordsController
  before_action :only_admin!, except: :new
  # GET /resource/password/new
  def new
   flash[:alert] = "アクセス権限がありません"
   redirect_to root_path
  end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
