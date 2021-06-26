class VendorManagers::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_supplier_manager!

  def edit
    @supplier = current_supplier_manager.supplier
    @industries = Industry.order(position: :asc)
  end

  def update
    @supplier_manager = current_supplier_manager
    if params[:supplier_manager][:password].blank? && params[:supplier_manager][:password_confirmation].blank?
      params[:supplier_manager].delete(:password)
      params[:supplier_manager].delete(:password_confirmation)
    end
    if @supplier_manager.update(supplier_manager_params)
      sign_in(@supplier_manager, :bypass => true)
      flash[:notice] = "アカウント情報を更新しました。"
      redirect_to top_supplier_managers_path
    else
      render :edit
    end
  end

  private
    def supplier_manager_params
      params.require(:supplier_manager).permit(:name, :login_id, :email, :phone, :password, :password_confirmation)
    end
end
