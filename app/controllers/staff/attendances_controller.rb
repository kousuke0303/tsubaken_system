class Staff::AttendancesController < ApplicationController

  
  def going_to_work
    if @attendance = current_staff.attendances.create!(worked_on: Date.today, started_at: Time.current, matter_id: params[:staffs_attendance][:matter_id])
      flash[:success] = "おはようございます！"
    end
      redirect_to top_staff_url(current_staff)
  end

  def leaving_work
    if @attendance = current_staff.attendances.update(worked_on: Date.today, finished_at: Time.current)
      flash[:success] = "お疲れ様でした"
    end
      redirect_to top_staff_url(current_staff)
  end

  def show
  end
  
  def update

  end


  def index
    # @submanager = Submanager.find(params[:id])
  end


  def edit
  end
  
  
  private
  
    def set_staff
      @staff = Staff.find(params[:id])
    end
  
end
