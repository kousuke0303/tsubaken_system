class Managers::Settings::ManagerEventsController < ApplicationController
  before_action :set_manager_event, only: [:edit, :update, :destroy]
  
  def create
    @manager_event = ManagerEvent.new(manager_event_params)
    if @manager_event.save
      ManagerEventTitle.create!(event_name: @manager_event.event_name, manager_id: current_manager.id, note: params[:manager_event][:note])
      flash[:success] = "#{@manager_event.event_name}を登録しました"
      redirect_to manager_events_url(current_manager)
    else
      redirect_to manager_events_url(current_manager)
    end
  end

  def edit
  end

  def update
    ManagerEventTitle.find_by(event_name: @manager_event.event_name, manager_id: current_manager.id).destroy
    if @manager_event.update_attributes(manager_event_params)
      ManagerEventTitle.create!(event_name: @manager_event.event_name, manager_id: current_manager.id, note: params[:manager_event][:note])
      flash[:success] = "#{@manager_event.event_name}の情報を更新しました"
      if manager_signed_in?
        redirect_to manager_events_url(current_manager)
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    if @manager_event.destroy
      if ManagerEventTitle.find_by(event_name: @manager_event.event_name, manager_id: current_manager.id).present?
        ManagerEventTitle.find_by(event_name: @manager_event.event_name, manager_id: current_manager.id).destroy
      end
      flash[:success] = "#{@manager_event.event_name}を削除しました"
      redirect_to manager_events_url(current_manager)
    end
  end
  
  private

    def manager_event_params
      params.require(:manager_event).permit(:id, :event_name, :event_type, :note, :date, :manager_id)
    end
    
    def set_manager_event
      @manager_event = ManagerEvent.find(params[:id])
    end
end