class VendorManagers::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_vendor_manager!

  def edit
    @vendor = current_vendor_manager.vendor
    @industries = Industry.order(position: :asc)
  end

  def update
    @vendor_manager = current_vendor_manager
    if params[:vendor_manager][:password].blank? && params[:vendor_manager][:password_confirmation].blank?
      params[:vendor_manager].delete(:password)
      params[:vendor_manager].delete(:password_confirmation)
    end
    if @vendor_manager.update(vendor_manager_params)
      bypass_sign_in(@vendor_manager)
      flash[:notice] = "アカウント情報を更新しました。"
      redirect_to top_vendor_managers_path
    else
      render :edit
    end
  end

  private
    def vendor_manager_params
      params.require(:vendor_manager).permit(:name, :login_id, :email, :phone, :password, :password_confirmation)
    end
end
