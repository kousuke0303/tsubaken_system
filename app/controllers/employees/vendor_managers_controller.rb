class Employees::VendorManagersController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_vendor_manager, except: [:new, :create, :index]
  before_action :set_variable, only: [:show, :update, :pass_update]

  def new
    @vendor = Vendor.find(params[:id])
    @vendor_manager = VendorManager.new
  end

  def create
    @vendor = Vendor.find(params[:id])
    @vendor_manager = VendorManager.new(vendor_manager_params.merge(password: "password", password_confirmation: "password"))
    @vendor_manager.vendor_id = @vendor.id
    if @vendor_manager.save
      @responce = "success"
    end
  end

  def index
    @enrolled_vendor_managers = VendorManager.enrolled.with_departments
    @retired_vendor_managers = VendorManager.retired.with_departments
  end

  def show
  end

  def update
    if update_resource(@vendor_manager, vendor_manager_params)
      @responce = "success"
    end
  end

  def pass_update
    if @vendor_manager.update(vendor_manager_pass_params)
      @responce = "success"
    end
  end

  def destroy
    @vendor_manager.accept = params[:vendor_manager][:accept].to_i
    if @vendor_manager.valid?(:destroy_check) && @vendor_manager.relation_destroy
      flash[:notice] = "#{ @vendor_manager.name }を削除しました"
      redirect_to employees_vendor_managers_url
    end
  end



  private
    def vendor_manager_params
      params.require(:vendor_manager).permit(:name, :kana, :login_id, :phone, :email, :birthed_on, :joined_on, :resigned_on)
    end

    def vendor_manager_pass_params
      params.require(:vendor_manager).permit(:password, :password_confirmation)
    end

    def set_vendor_manager
      @vendor_manager = VendorManager.find(params[:id])
    end

    def set_vendor
      @vendor = Vendor.find(params[:vendor_id])
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
