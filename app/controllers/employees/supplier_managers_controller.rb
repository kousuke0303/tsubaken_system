class Employees::SupplierManagersController < Employees::EmployeesController

  before_action :authenticate_admin_or_manager!
  before_action :set_supplier_manager, except: [:new, :create, :index]
  before_action :set_variable, only: [:show, :update, :pass_update]
  
  def new
    @supplier = Supplier.find(params[:id])
    @supplier_manager = SupplierManager.new
  end

  def create
    @supplier = Supplier.find(params[:id])
    @supplier_manager = SupplierManager.new(supplier_manager_params.merge(password: "password", password_confirmation: "password"))
    @supplier_manager.supplier_id = @supplier.id
    if @supplier_manager.save
      @responce = "success"
    end
  end

  def index
    @enrolled_supplier_managers = SupplierManager.enrolled.with_departments
    @retired_supplier_managers = SupplierManager.retired.with_departments
  end

  def show
  end

  def update
    if update_resource(@supplier_manager, supplier_manager_params)
      @responce = "success"
    end
  end
  
  def pass_update
    if @supplier_manager.update(supplier_manager_pass_params)
      @responce = "success"
    end
  end

  def destroy
    @supplier_manager.accept = params[:supplier_manager][:accept].to_i
    if @supplier_manager.valid?(:destroy_check) && @supplier_manager.relation_destroy
      flash[:notice] = "#{ @supplier_manager.name }を削除しました"
      redirect_to employees_supplier_managers_url
    end
  end
  
  

  private
    def supplier_manager_params
      params.require(:supplier_manager).permit(:name, :kana, :login_id, :phone, :email, :birthed_on, :joined_on, :resigned_on)
    end
    
    def supplier_manager_pass_params
      params.require(:supplier_manager).permit(:password, :password_confirmation)
    end

    def set_supplier_manager
      @supplier_manager = SupplierManager.find(params[:id])
    end
    
    def set_supplier
      @supplier = Supplier.find(params[:supplier_id])
    end
    
    def set_variable
      # @estimate_matters = @staff.estimate_matters.with_sales_statuses.group_by{ |sales_status| sales_status.estimate_matter_id }
      # @matters = @staff.matters
      # @tasks = @matters.joins(:tasks).where(tasks: { member_code_id: @staff.member_code.id})
      #                 .select('matters.title AS matter_title', 'tasks.*')
    end
    
    def set_staff_task
      # @tasks = @staff.tasks.where.not(status: 3)
      # @tasks_for_estimate_matter = @tasks.joins(:estimate_matter)
      # @tasks_for_matter = @tasks.joins(:matter)
      # @tasks_for_individual = @tasks.individual
    end
end
