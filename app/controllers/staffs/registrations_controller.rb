# frozen_string_literal: true

class Staffs::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_staff!
  before_action :set_label_colors
  before_action :set_departments
  

  def update
    @staff = Staff.find(current_staff.id)
    if params[:staff][:password].blank? && params[:staff][:password_confirmation].blank?
      params[:staff].delete(:password)
      params[:staff].delete(:password_confirmation)
    end
    if @staff.update(staff_params)
      bypass_sign_in(@staff)
      flash[:notice] = "アカウント情報を更新しました。"
      redirect_to staffs_top_url
    else
      render :edit
    end
  end

  private
    def staff_params
      params.require(:staff).permit(:name, :login_id, :phone, :email, :birthed_on, :postal_code, 
                                    :prefecture_code, :address_city, :address_street, :joined_on,
                                    :resigned_on, :department_id, :label_color_id, :password, :password_confirmation)
    end
end
