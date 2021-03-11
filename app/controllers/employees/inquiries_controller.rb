class Employees::InquiriesController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_inquiry, only: [:show, :edit, :update, :destroy]

  def index
    @unsolved_inquiries = Inquiry.all.where(solved_at: nil)
    @solved_inquiries = Inquiry.all.where.not(solved_at: nil)
  end

  def show
    @clients = Client.search_by_inquiry(@inquiry.name, @inquiry.kana, @inquiry.phone, @inquiry.email)
  end

  def edit
  end

  def update
    if @inquiry.update(inquiry_params)
      flash[:notice] = "お問合せを更新しました。"
      redirect_to employees_inquiry_url(@inquiry)
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

    def inquiry_params
      params.require(:inquiry).permit(:solved_at, :note)
    end
end
