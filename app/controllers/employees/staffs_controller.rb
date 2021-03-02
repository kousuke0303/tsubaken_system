class Employees::StaffsController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_label_colors, only: [:new, :edit]
  before_action :set_staff, only: [:show, :edit, :update, :destroy]
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
    @estimate_matters = @staff.estimate_matters.left_joins(:sales_statuses).select(
      "estimate_matters.*",
      "sales_statuses.*",
      "sales_statuses.estimate_matter_id AS estimate_matter_id",
      "sales_statuses.created_at AS sales_status_created_at",
    ).group_by{ |sales_status| sales_status.estimate_matter_id }
    @matters = @staff.matters
  end

  def update
    if @staff.update(staff_params)
      flash[:success] = "Staff情報を更新しました。"
      redirect_to employees_staff_url(@staff)
    end
  end

  def destroy
    @staff.destroy ? flash[:success] = "Staffを削除しました。" : flash[:alert] = "Staffを削除できませんでした。"
    redirect_to employees_staffs_url
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
