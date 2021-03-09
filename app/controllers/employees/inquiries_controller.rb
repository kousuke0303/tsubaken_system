class Employees::InquiriesController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_inquiry, only: [:edit, :update, :destroy]

  def index
    @inquiries = Inquiry.all
  end

  def edit
  end

  def update
    if @inquiry.update
      flash[:notice] = "お問合せを更新しました。"
      redirect_to employees_inquiries_url
    end
  end

  def destroy
    @inquiry.destroy ? flash[:notice] = "お問合せを削除しました。" : flash[:alert] = "お問合せの削除に失敗しました。"
    redirect_to employees_inquiries_url
  end

  private
    def set_inquiry
      @inquiry = Inquiry.find(params[:id])
    end
end
