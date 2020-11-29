class Employees::MattersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_matter, only: [:show, :edit, :update, :destroy]
  before_action :set_matter_support, only: [:new, :edit]

  def index
    # 案件を持っている顧客のみを選択しにする
    @clients = Client.joins(:matters).distinct

    # 全案件を顧客情報と一緒に取得
    @matters = Matter.includes(:client)

    # 顧客での絞り込みがあった場合
    if params[:client_id] && params[:client_id].present?
      client = Client.find(params[:client_id])
      @matters = client.matters 
    end

    # 進行状況での絞り込みがあった場合
    if params[:status] && params[:status] == "not_started"
      @matters = @matters.not_started
    elsif params[:status] && params[:status] == "progress"
      @matters = @matters.progress
    elsif params[:status] && params[:status] == "completed"
      @matters = @matters.completed
    end
  end
  
  def new
    @matter = Matter.new
    @clients = Client.all
  end

  def create
    @matter = Matter.new(matter_params)
    if @matter.save
      flash[:success] = "案件を作成しました。"
      redirect_to employees_matter_url(@matter)
    else
      render :new
    end
  end

  def show
    @managers = @matter.managers
    @staffs = @matter.staffs
    @suppliers = @matter.suppliers
    @tasks = @matter.tasks
    set_classified_tasks(@matter)
  end

  def edit
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

    def set_matter_support
      @clients = Client.all
      @managers = Manager.all
      @staffs = Staff.all
      @suppliers = Supplier.all
    end

    def matter_params
      params.require(:matter).permit(:title, :client_id, :zip_code, :actual_spot, :scheduled_started_on, :scheduled_finished_on, :status,
                                     :started_on, :finished_on, :maintenanced_on, { manager_ids: [] }, { staff_ids: [] }, { supplier_ids: [] })
    end
end
