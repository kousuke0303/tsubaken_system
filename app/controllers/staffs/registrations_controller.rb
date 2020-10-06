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
      flash[:success] = "アカウント情報を更新しました."
      redirect_to top_staff_url(@staff)
    else
      render :edit
    end
  end

  private
    def staff_params
      params.require(:staff).permit(:name, :employee_id, :phone, :email, :zip_code, :address, :joined_on, :resigned_on, :password, :password_confirmation)
    end
end
