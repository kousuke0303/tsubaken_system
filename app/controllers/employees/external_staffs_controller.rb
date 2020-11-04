class Employees::ExternalStaffsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_external_staff, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier, only: [:create, :show, :edit, :update, :destroy]

  def create
    @external_staff = @supplier.external_staffs.new(external_staff_params.merge(password: "password", password_confirmation: "password"))
    if @external_staff.save
      flash[:success] = "外部Staffを作成しました。"
      redirect_to employees_supplier_external_staff_path(@supplier, @external_staff)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    # login_idの先頭部分以外を定義
    @login_id_body = @external_staff.login_id_body
  end

  def update
    if @external_staff.update(external_staff_params)
      flash[:success] = "外部Staff情報を更新しました。"
      redirect_to employees_supplier_external_staff_path(@supplier, @external_staff)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @external_staff.destroy ? flash[:success] = "外部Staffを削除しました。" : flash[:alert] = "外部Staffを削除できませんでした。"
    redirect_to employees_supplier_path(@supplier)
  end

  private
    def external_staff_params
      params.require(:external_staff).permit(:name, :kana, :login_id, :login_id_body, :phone, :email, :supplier_id)
    end

    def set_external_staff
      @external_staff = ExternalStaff.find(params[:id])
    end

    def set_supplier
      @supplier = Supplier.find(params[:supplier_id])
    end
end
