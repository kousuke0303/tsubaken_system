# frozen_string_literal: true

class ExternalStaffs::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_external_staff!

  def update
    @external_staff = ExternalStaff.find(current_external_staff.id)
    if params[:external_staff][:password].blank? && params[:external_staff][:password_confirmation].blank?
      params[:external_staff].delete(:password)
      params[:external_staff].delete(:password_confirmation)
    end
    if @external_staff.update(external_staff_params)
      sign_in(@external_staff, :bypass => true)
      flash[:alert] = "アカウント情報を更新しました。"
      redirect_to top_external_staff_url(@external_staff)
    else
      render :edit
    end
  end

  private
    def external_staff_params
      params.require(:external_staff).permit(:name, :login_id, :phone, :email, :password, :password_confirmation)
    end
end
