class Api::V1::Employees::StaffsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_staff, only: [:show, :update, :destroy]

  def index
    if params[:status] == "enrolled"
      staffs = Staff.enrolled
      render json: staffs, each_sserializer: StaffSerializer
    elsif params[:status] == "retired"
      staffs = Staff.retired
      render json: staffs, each_sserializer: StaffSerializer
    else
      render json: { status: "false", message: "Staffを取得できませんでした" }
    end
  end
  
  def show
    render json: @staff, serializer: StaffSerializer, include: :matters
  end

  def create
    staff = Staff.new(staff_params.merge(password: "password", password_confirmation: "password"))
    if staff.save
      render json: staff, serializer: StaffSerializer
    else
      render json: { status: "false", message: staff.errors.full_messages }
    end
  end

  def update
    if @staff.update(staff_params)
      render json: @staff, serializer: StaffSerializer
    else
      render json: { status: "false", message: @staff.errors.full_messages }
    end
  end

  def destroy
    if @staff.destroy
      render json: @staff, serializer: StaffSerializer
    else
      render json: { status: "false", message: @staff.errors.full_messages }
    end
  end

  private
    def staff_params
      params.permit(:name, :login_id, :phone, :email, :birthed_on, :postal_code, :prefecture_code, :address_city, :address_street, :department_id, :joined_on, :resigned_on)
    end

    def set_staff
      @staff = Staff.find(params[:id])
    end
end
