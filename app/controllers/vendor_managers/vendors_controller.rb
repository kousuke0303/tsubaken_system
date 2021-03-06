class VendorManagers::VendorsController < ApplicationController
  before_action :authenticate_vendor_manager!
  before_action :set_vendor
  before_action :own_company


  def update
    @industries = Industry.order(position: :asc)
    @vendor_manager = current_vendor_manager
    if @vendor.update(vendor_params)
      flash[:success] = "会社情報を更新しました"
      redirect_to edit_vendor_manager_registration_path(@vendor.vendor_manager)
    else
      flash.now[:alert] = "会社情報の更新に失敗しました"
      @error_type = "vendor"
      render "vendor_managers/registrations/edit"
    end
  end

  private
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    def vendor_params
      params.require(:vendor).permit(:name, :kana, :representative, :phone_1, :phone_2, :fax, :email, :postal_code, :prefecture_code, :address_city, :address_street, { :industry_ids=> [] })
    end
    
    def own_company
      unless @vendor.id == login_user.vendor.id
        sign_out(login_user)
        flash[:alert] = "アクセス権限がありません"
        redirect_to root_url
      end
    end
end
