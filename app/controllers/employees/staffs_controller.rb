class Employees::StaffsController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_label_colors, only: [:new, :edit]
  before_action :set_staff, except: [:new, :create, :index]
  before_action :set_departments, only: [:new, :edit]
  
  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params.merge(password: "password", password_confirmation: "password"))
    if @staff.save
      flash[:success] = "Staffを作成しました。"
      redirect_to employees_staff_url(@staff)
    end
  end

  def index
    @enrolled_staffs = Staff.enrolled.with_departments
    @retired_staffs = Staff.retired.with_departments
  end

  def edit
  end

  def show
    @department_name = @staff.department.name
    @label_color = @staff.label_color
    @estimate_matters = @staff.estimate_matters.with_sales_statuses.group_by{ |sales_status| sales_status.estimate_matter_id }
    @matters = @staff.matters
    @tasks = @matters.joins(:tasks).where(tasks: { staff_id: @staff.id})
                    .select('matters.title AS matter_title', 'tasks.*')
  end

  def update
    if @staff.update(staff_params)
      flash[:success] = "Staff情報を更新しました。"
      redirect_to employees_staff_url(@staff)
    end
  end
  
  def retirement_process
    @matters = @staff.matters.where.not(status:2)
    @tasks = Matter.joins(:tasks)
                   .where(tasks: { staff_id: @staff.id })
                   .where.not(tasks: { status: 3})
                   .select('matters.id AS matter_id, matters.title AS matter_title', 'tasks.*')
    @schedules = @staff.schedules.where('scheduled_date >= ?', Date.today)
  end
  
  def resigend_registor
    if @staff.update(resigned_on: params[:staff][:resigned_on])
      flash[:success] = "退職日を登録しました"
    end
    redirect_to retirement_process_employees_staff_url(@staff)
  end

  def destroy
    if @staff.destroy
      if @delete_type == false
        flash[:info] = "#{@staff}及びこのSTAFFに関するスケジュールを削除しました"
      else
        flash[:info] = "#{@staff}を削除しました"
      end
      redirect_to employees_staffs_url
    else
      @responce = "failure"
      @label_color = @staff.label_color
    end
  end

  private
    def staff_params
      params.require(:staff).permit(:name, :login_id, :phone, :email, :birthed_on, :postal_code, :prefecture_code, :address_city, :address_street,
                                    :label_color_id, :department_id, :joined_on, :resigned_on)
    end

    def set_staff
      @staff = Staff.find(params[:id])
    end
end
