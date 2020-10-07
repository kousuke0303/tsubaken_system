class Admins::ManagersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_manager_by_admin, only: [:show, :edit, :update, :destroy]

  def new
    @manager = Manager.new
  end

  def create
    @manager = Manager.create(manager_params)
    if @manager.save
      flash[:alert] = "マネージャーを作成しました"
      redirect_to admin_manager_url(current_admin, @manager)
    else
      render :new
    end
  end

  def index
    @managers = Manager.all
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def manager_params
      params.require(:manager).permit(:name, :employee_id, :phone, :email, :zipcode, :address, :joined_on, :resigned_on).
             merge(password: "password", password_confirmation: "password")
    end

    def set_manager_by_admin
      @manager = Manager.find(params[:id])
    end
end
