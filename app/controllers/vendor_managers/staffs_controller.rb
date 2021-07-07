class VendorManagers::StaffsController < ApplicationController
  before_action :authenticate_vendor_manager!
  before_action :authenticate_boss!, except: [:index, :new, :create]
  
  def index
    staffs = current_vendor_manager.staffs
    @enrolled_staffs = staffs.enrolled
    @retired_staffs = staffs.retired
  end
  
  def new
    @vendor = current_vendor_manager.vendor
    @external_staff = @vendor.external_staffs.new
  end
  
  def create
    @vendor = current_vendor_manager.vendor
    @external_staff = @vendor.external_staffs.new(external_staff_params.merge(password: "password", password_confirmation: "password"))
    if @external_staff.save
      flash[:success] = "Staffを作成しました"
      redirect_to vendor_managers_staff_url(@external_staff)
    end
  end
  
  def show
  end
  
  def update
    if update_resource(@external_staff, external_staff_params)
      flash[:success] = "Staffを更新しました"
      redirect_to vendor_managers_staff_url(@external_staff)
    else
      render "show"
    end
  end
  
  def pass_update
    if @external_staff.update(external_staff_pass_params)
      flash[:success] = "パスワードを更新しました"
      redirect_to vendor_managers_staff_url(@external_staff)
    else
      render :show
    end
  end
  
  def restoration
    @external_staff.update(resigned_on: "", avaliable: true)
    flash[:success] = "#{ @external_staff.name }のアカウントが利用できるようになりました"
    redirect_to vendor_managers_staff_url(@external_staff)
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
    
    def authenticate_boss!
      @external_staff = ExternalStaff.find(params[:id])
      if @external_staff.vendor != login_user.vendor
        sign_out(login_user)
        flash[:alert] = "アクセス権限がありません"
        redirect_to root_url
      end
    end

end
