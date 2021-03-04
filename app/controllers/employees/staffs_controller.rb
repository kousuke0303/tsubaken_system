class Employees::StaffsController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_label_colors, only: [:new, :edit]
  before_action :set_staff, only: [:show, :edit, :update, :delete_confirmation, :destroy]
  before_action :set_departments, only: [:new, :edit]
  before_action :has_schedule, only: [:show, :delete_confirmation]
  
  
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
  end

  def update
    if @staff.update(staff_params)
      flash[:success] = "Staff情報を更新しました。"
      redirect_to employees_staff_url(@staff)
    end
  end
  
  def delete_confirmation
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
    
    def has_schedule
      if Schedule.where(staff_id: @staff.id).where('scheduled_date >= ?', Date.today).present?
        @staff_schedules = Schedule.where(staff_id: @staff.id).where('scheduled_date >= ?', Date.today)
        @delete_type = false
      else
        @delete_type = true
      end
    end
end
