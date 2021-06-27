class Employees::ExternalStaffsController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_vendors, only: [:new, :show, :update, :pass_update]
  before_action :set_external_staff, except: [:new, :create, :index]

  def new
    @external_staff = ExternalStaff.new
  end

  def create
    @external_staff = ExternalStaff.new(external_staff_params.merge(password: "password", password_confirmation: "password"))
    if @external_staff.save
      flash[:success] = "外部Staffを作成しました"
      redirect_to employees_external_staff_url
    end
  end

  def index
    @external_staffs = ExternalStaff.all
  end

  def show
    @vendor = @external_staff.vendor
  end

  def edit
  end

  def update
    if update_resource(@external_staff, external_staff_params)
      flash[:success] = "外部Staffを更新しました"
      redirect_to employees_external_staff_url(@external_staff)
    else
      render "show"
    end
  end

  def pass_update
    if @external_staff.update(external_staff_pass_params)
      flash[:success] = "パスワードを更新しました"
      redirect_to employees_external_staff_url(@external_staff)
    else
      render :show
    end
  end

  def out_of_service
    if @external_staff.update(resigned_on: Date.current)
      flash[:notice] = "#{ @external_staff.name }のアカウントを停止しました"
    end
    redirect_to employees_external_staff_url(@external_staff)
  end

  def destroy
    @external_staff.accept = params[:external_staff][:accept].to_i
    if @external_staff.valid?(:destroy_check) && @external_staff.relation_destroy
      flash[:notice] = "#{ @external_staff.name }を削除しました"
      redirect_to employees_external_staffs_url
    end
  end

  def restoration
    @external_staff.update(resigned_on: "", avaliable: true)
    flash[:success] = "#{ @external_staff.name }のアカウントが利用できるようになりました"
    redirect_to employees_external_staff_url(@external_staff)
  end

  private
    def external_staff_params
      params.require(:external_staff).permit(:name, :kana, :login_id, :phone, :email, :vendor_id)
    end

    def external_staff_pass_params
      params.require(:external_staff).permit(:password, :password_confirmation)
    end

    def set_external_staff
      @external_staff = ExternalStaff.find(params[:id])
    end
end
