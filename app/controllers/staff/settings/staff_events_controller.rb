class Staff::Settings::StaffEventsController < ApplicationController
  before_action :set_staff_event, only: [:edit, :update, :destroy]

  def create
    @staff_event = StaffEvent.new(staff_event_params)
    if @staff_event.save
      StaffEventTitle.create!(event_name: @staff_event.event_name, staff_id: current_staff.id, note: params[:staff_event][:note])
      flash[:success] = "#{@staff_event.event_name}を登録しました"
      redirect_to staff_events_url(current_staff)
    else
      redirect_to staff_events_url(current_staff)
    end
  end

  def edit
  end

  def update
    StaffEventTitle.find_by(event_name: @staff_event.event_name, staff_id: current_staff.id).destroy
    if @staff_event.update_attributes(staff_event_params)
      StaffEventTitle.create!(event_name: @staff_event.event_name, staff_id: current_staff.id, note: params[:staff_event][:note])
      flash[:success] = "#{@staff_event.event_name}の情報を更新しました"
      if staff_signed_in?
        redirect_to staff_events_url(current_staff)
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    if @staff_event.destroy
      if StaffEventTitle.find_by(event_name: @staff_event.event_name, staff_id: current_staff.id).present?
        StaffEventTitle.find_by(event_name: @staff_event.event_name, staff_id: current_staff.id).destroy
      end
      flash[:success] = "#{@staff_event.event_name}を削除しました"
      redirect_to staff_events_url(current_staff)
    end
  end

  private

    def staff_event_params
      params.require(:staff_event).permit(:id, :event_name, :event_type, :note, :date, :staff_id)
    end

    def set_staff_event
      @staff_event = StaffEvent.find(params[:id])
    end
end
