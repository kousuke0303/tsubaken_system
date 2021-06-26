class Api::V1::ExternalStaffs::RegistrationsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api

  def update_self
    @external_staff = ExternalStaff.find(params[:id])
    if @external_staff.update(external_staff_params)
      render json: @external_staff, serializer: ExternalStaffSerializer
    else
      render json: { status: "false", message: @external_staff.errors.full_messages }
    end
  end

  private
    def external_staff_params
      params.permit(:name, :kana, :phone, :email, :login_id, :vendor_id)
    end
end
