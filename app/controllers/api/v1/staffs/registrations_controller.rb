class Api::V1::Staffs::RegistrationsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api

  def update_self
    @staff = Staff.find(params[:id])
    if @staff.update(staff_params)
      render json: @staff, serializer: StaffSerializer
    else
      render json: { status: "false", message: @staff.errors.full_messages }
    end
  end

  private
    def staff_params
      params.permit(:name, :login_id, :phone, :email, :birthed_on, :zip_code, :address, :joined_on, :resigned_on)
    end
end
