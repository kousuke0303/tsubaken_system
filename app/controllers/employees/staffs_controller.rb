class Employees::StaffsController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_staff, except: [:new, :create, :index]
  before_action :set_label_colors, only: [:new, :show, :update, :pass_update]
  before_action :set_departments, only: [:new, :show, :update, :pass_update]
  before_action :set_variable, only: [:show, :update, :pass_update]
  
  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params.merge(password: "password", password_confirmation: "password"))
    if @staff.save
      flash[:success] = "Staffを作成しました"
      redirect_to employees_staff_url(@staff)
    end
  end

  def index
    @enrolled_staffs = Staff.enrolled.with_departments
    @retired_staffs = Staff.retired.with_departments
  end

  def show
  end

  def update
    if update_resource(@staff, staff_params)
      flash[:success] = "Staff情報を更新しました"
      redirect_to employees_staff_url(@staff)
    else
      render :show
    end
  end
  
  def pass_update
    if @staff.update(staff_pass_params)
      flash[:success] = "パスワードを更新しました"
      redirect_to employees_staff_url(@staff)
    else
      render :show
    end
  end

  def destroy
    @staff.accept = params[:staff][:accept].to_i
    if @staff.valid?(:destroy_check) && @staff.relation_destroy
      flash[:notice] = "#{ @staff.name }を削除しました"
      redirect_to employees_staffs_url
    end
  end

  private
    def staff_params
      params.require(:staff).permit(:name, :login_id, :phone, :email, :birthed_on, :postal_code, :prefecture_code, :address_city, :address_street,
                                    :label_color_id, :department_id, :joined_on, :resigned_on)
    end
    
    def staff_pass_params
      params.require(:staff).permit(:password, :password_confirmation)
    end

    def set_staff
      @staff = Staff.find(params[:id])
    end
    
    def set_variable
      @department_name = @staff.department.name
      @label_color = @staff.label_color
      @estimate_matters = @staff.estimate_matters.with_sales_statuses.group_by{ |sales_status| sales_status.estimate_matter_id }
      @matters = @staff.matters
      @tasks = @matters.joins(:tasks).where(tasks: { member_code_id: @staff.member_code.id})
                       .select('matters.title AS matter_title', 'tasks.*')
    end
    
    def set_staff_task
      @tasks = @staff.tasks.where.not(status: 3)
      @tasks_for_estimate_matter = @tasks.joins(:estimate_matter)
      @tasks_for_matter = @tasks.joins(:matter)
      @tasks_for_individual = @tasks.individual
    end
end
