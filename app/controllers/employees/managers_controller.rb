class Employees::ManagersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_manager, only: [:show, :edit, :update, :destroy]
  before_action :set_department, only: [:new, :create, :edit, :update]

  def new
    @manager = Manager.new
  end

  def create
    @manager = Manager.new(manager_params.merge(password: "password", password_confirmation: "password"))
    if @manager.save
      flash[:success] = "マネージャーを作成しました"
      redirect_to employees_manager_url(@manager)
    else
      render :new
    end
  end

  def index
    @managers = Manager.all
  end

  def show
    @department_name = Department.find(@manager.department_id).name
  end

  def edit
  end

  def update
    if @manager.update(manager_params)
      flash[:success] = "マネージャー情報を更新しました"
      redirect_to employees_manager_url(@manager)
    else
      render :edit
    end
  end

  def destroy
    @manager.destroy ? flash[:success] = "マネージャーを削除しました" : flash[:alert] = "マネージャーを削除できませんでした"
    redirect_to employees_managers_url
  end

  private
    def manager_params
      params.require(:manager).permit(:name, :login_id, :phone, :email, :birthed_on, :zipcode, :address, :department_id, :joined_on, :resigned_on)
    end

    def set_manager
      @manager = Manager.find(params[:id])
    end
    
    def set_department
      @departments = Department.all
    end
end
