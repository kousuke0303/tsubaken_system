class VendorManagers::VendorsController < ApplicationController
  before_action :authenticate_vendor_manager!
  before_action :set_vendor


  def update
    if @vendor.update(vendor_params)
      flash[:success] = "外注先を更新しました"
      redirect_to edit_vendor_manager_registration_path(@vendor.vendor_manager)
    end
  end

  private
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    def vendor_params
      params.require(:vendor).permit(:name, :kana, :representative, :phone_1, :phone_2, :fax, :email, :postal_code, :prefecture_code, :address_city, :address_street, { :industry_ids=> [] })
    end
end
