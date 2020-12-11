class Api::V1::Employees::ManagersController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_manager, only: [:show, :update, :destroy]

  def index
    if params[:status] == "enrolled"
      managers = Manager.enrolled
      render json: managers, each_sserializer: ManagerSerializer
    elsif params[:status] == "retired"
      managers = Manager.retired
      render json: managers, each_sserializer: ManagerSerializer
    else
      render json: { status: "false", message: "Managerを取得できませんでした" }
    end
  end
  
  def show
    render json: @manager, serializer: ManagerSerializer, include: :matters
  end

  def create
    manager = Nanager.new(params.merge(password: "password", password_confirmation: "password"))
    if manager.save
      render json: manager, serializer: ManagerSerializer
    else
      render json: { status: "false", message: manager.errors.full_messages }
    end
  end

  def update
    if @manager.update(params)
      render json: @manager, serializer: ManagerSerializer
    else
      render json: { status: "false", message: @manager.errors.full_messages }
    end
  end

  def destroy
    if @manager.destroy
      render json: @manager, serializer: ManagerSerializer
    else
      render json: { status: "false", message: @manager.errors.full_messages }
    end
  end

  private
    def params
      params.permit(:name, :login_id, :phone, :email, :birthed_on, :postal_code, :prefecture_code, :address_city, :address_street, :department_id, :joined_on, :resigned_on)
    end

    def set_manager
      @manager = Manager.find(params[:id])
    end
end
