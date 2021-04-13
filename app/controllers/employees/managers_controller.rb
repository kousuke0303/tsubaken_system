class Employees::ManagersController < Employees::EmployeesController
  before_action :authenticate_admin!, only: [:new, :create, :update, :destroy]
  before_action :authenticate_admin_or_manager!, only: [:index, :show]
  before_action :set_manager, except: [:new, :create, :index]
  before_action :set_departments, only: [:new, :show, :update, :pass_update]

  def new
    @manager = Manager.new
  end

  def create
    @manager = Manager.new(manager_params.merge(password: "password", password_confirmation: "password"))
    if @manager.save
      flash[:success] = "Managerを作成しました"
      redirect_to employees_manager_url(@manager)
    end
  end

  def index
    @enrolled_managers = Manager.enrolled.with_departments
    @retired_managers = Manager.retired.with_departments
  end

  def show
  end

  def update
    if update_resource(@manager, manager_params)
      flash[:success] = "Manager情報を更新しました"
      redirect_to employees_manager_url(@manager)
    else
      render :show
    end
  end
  
  def pass_update
    if @manager.update(manager_pass_params)
      flash[:success] = "パスワードを更新しました"
      redirect_to employees_manager_url(@manager)
    else
      render :show
    end
  end

  def destroy
    @manager.accept = params[:manager][:accept].to_i
    if @manager.valid?(:destroy_check) && @manager.relation_destroy
      flash[:notice] = "#{ @manager.name }を削除しました"
      redirect_to employees_managers_url
    end
  end
  
  def restoration
    @manager.update(resigned_on: "", avaliable: true)
    flash[:success] = "#{ @manager.name }のアカウントが利用できるようになりました"
    redirect_to employees_manager_url(@manager)
  end

  private
    def manager_params
      params.require(:manager).permit(:name, :login_id, :phone, :email, :birthed_on, :postal_code, :prefecture_code, :address_city,
                                      :address_street, :department_id, :joined_on, :resigned_on)
    end
    
    def manager_pass_params
      params.require(:manager).permit(:password, :password_confirmation)
    end
    
    def set_manager
      @manager = Manager.find(params[:id])
    end 
end
