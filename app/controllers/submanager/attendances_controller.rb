class Submanager::AttendancesController < ApplicationController

  
  def going_to_work
    if @attendance = current_submanager.attendances.create!(worked_on: Date.today, started_at: Time.current, matter_id: params[:submanagers_attendance][:matter_id])
      flash[:success] = "おはようございます！"
    end
      redirect_to top_submanager_url(dependent_manager, current_submanager)
  end

  def leaving_work
    if @attendance = current_submanager.attendances.update(worked_on: Date.today, finished_at: Time.current)
      flash[:success] = "お疲れ様でした"
    end
      redirect_to top_submanager_url(dependent_manager, current_submanager)
  end

  def show
  end
  
  def update

  end


  def edit
  end
  
  
  private
  
    def set_staff
      @staff = Staff.find(params[:id])
    end
  
end
