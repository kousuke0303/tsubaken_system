# frozen_string_literal: true

class Staffs::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_staff!

  def update
    @staff = Staff.find(current_staff.id)
    if params[:staff][:password].blank? && params[:staff][:password_confirmation].blank?
      params[:staff].delete(:password)
      params[:staff].delete(:password_confirmation)
    end
    if @staff.update(staff_params)
      sign_in(@staff, :bypass => true)
      flash[:alert] = "アカウント情報を更新しました。"
      redirect_to staffs_top_url
    else
      render :edit
    end
  end

  private
    def staff_params
      params.require(:staff).permit(:name, :login_id, :phone, :email, :birthed_on, :zip_code, :address, :joined_on, :resigned_on, :password, :password_confirmation)
    end
end
