class Employees::ExternalStaffsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_external_staff, only: [:show, :edit, :update, :destroy]

  def create
    @external_staff = ExternalStaff.new(external_staff_params.merge(password: "password", password_confirmation: "password"))
    if @external_staff.save
      flash[:success] = "外部スタッフを作成しました"
      redirect_to employees_external_staff_url(@external_staff)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @external_staffs = ExternalStaff.all
    @external_staff = ExternalStaff.new
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    @external_staff.destroy ? flash[:success] = "外部スタッフを削除しました" : flash[:alert] = "外部スタッフを削除できませんでした"
    redirect_to employees_external_staffs_path
  end

  private
    def external_staff_params
      params.require(:external_staff).permit(:name, :kana, :login_id, :login_id_body, :phone, :email, :supplier_id)
    end

    def set_external_staff
      @external_staff = ExternalStaff.find(params[:id])
    end
end
