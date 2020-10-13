class Employees::MattersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_matter, only: [:show, :edit, :update, :destroy]

  def index
  end
  
  def new
    @matter = Matter.new
    @clients = Client.all
    @managers = Manager.all
    @staffs = Staff.all
    @suppliers = Supplier.all
  end

  def create
    @matter = Matter.new(matter_params)
    if @matter.save
      flash[:success] = "案件を作成しました"
      redirect_to employees_matter_url(@matter)
    else
      render :new
    end
  end

  def show
    @client = Client.find(@matter.client_id)
    @managers = @matter.managers
    @staffs = @matter.staffs
    @suppliers = @matter.suppliers
  end

  def edit
    @client = Client.find(@matter.client_id)
    @clients = Client.all
    @managers = Manager.all
    @staffs = Staff.all
    @suppliers = Supplier.all
  end

  def update
    if @matter.update(matter_params)
      flash[:success] = "案件情報を更新しました"
      redirect_to employees_matter_url(@matter)
    else
      render :edit
    end
  end

  def destroy
    @matter.destroy ? flash[:success] = "案件を削除しました" : flash[:alert] = "案件を削除できませんでした"
    redirect_to employees_matters_url
  end

  private
    def set_matter
      @matter = Matter.find(params[:id])
    end

    def matter_params
      params.require(:matter).permit(:title, :client_id, :zip_code, :actual_spot, :scheduled_started_on, :scheduled_finished_on,
                                     { :manager_ids=> [] }, { :staff_ids=> [] }, { :supplier_ids=> [] })
    end
end
