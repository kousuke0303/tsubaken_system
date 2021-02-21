class Employees::ExternalStaffsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_suppliers, only: [:new, :edit]
  before_action :set_external_staff, only: [:show, :edit, :update, :destroy]

  def new
    @external_staff = ExternalStaff.new
  end

  def create
    @external_staff = ExternalStaff.new(external_staff_params.merge(password: "password", password_confirmation: "password"))
    if @external_staff.save
      flash[:success] = "外部Staffを作成しました。"
      redirect_to employees_external_staff_url
    end
  end

  def index
    @external_staffs = ExternalStaff.all
  end

  def show
    @supplier = @external_staff.supplier
  end

  def edit
  end

  def update
    if @external_staff.update(external_staff_params)
      flash[:success] = "外部Staffを更新しました。"
      redirect_to employees_external_staff_url
    end
  end

  def destroy
    @external_staff.destroy ? flash[:success] = "外部Staffを削除しました。" : flash[:alert] = "外部Staffを削除できませんでした。"
    redirect_to employees_external_staffs_url
  end

  private
    def external_staff_params
      params.require(:external_staff).permit(:name, :kana, :login_id, :phone, :email, :supplier_id)
    end

    def set_external_staff
      @external_staff = ExternalStaff.find(params[:id])
    end
end
