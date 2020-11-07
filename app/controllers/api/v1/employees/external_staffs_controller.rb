class Api::V1::Employees::ExternalStaffsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_external_staff, only: [:update, :destroy]

  def create
    external_staff = ExternalStaff.new(external_staff_params)
    if external_staff.save
      render json: external_staff, serializer: ExternalStaffSerializer
    else
      render json: { status: "false", message: external_staff.errors.full_messages }
    end
  end

  def update
    if @external_staff.update(external_staff_params)
      render json: @external_staff, serializer: ExternalStaffSerializer
    else
      render json: { status: "false", message: @external_staff.errors.full_messages }
    end
  end

  def destroy
    if @external_staff.destroy
      render json: @external_staff, serializer: ExternalStaffSerializer
    else
      render json: { status: "false", message: @external_staff.errors.full_messages }
    end
  end

  private
    def external_staff_params
      params.permit(:name, :phone, :email, :supplier_id)
    end

    def set_external_staff
      @external_staff = ExternalStaff.find(params[:id])
    end
end
