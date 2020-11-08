class Api::V1::Admins::RegistrationsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api

  def update_self
    @admin = Admin.find(params[:id])
    if @admin.update(admin_params)
      render json: @admin, serializer: RegistrationSerializer
    else
      render json: { status: "false", message: @admin.errors.full_messages }
    end
  end

  private
    def admin_params
      params.permit(:auth, :name, :email, :phone, :login_id)
    end
end
