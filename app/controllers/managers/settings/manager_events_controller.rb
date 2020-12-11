class Managers::Settings::ManagerEventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]
  
  def create
    @event = ManagerEvent.new(event_params)
    if @event.save
      ManagerEventTitle.create!(event_name: @event.event_name, id: current_manager.id, note: params[:event][:note])
      flash[:success] = "#{@event.event_name}を登録しました"
      redirect_to events_url(current_manager)
    else
      redirect_to events_url(current_manager)
    end
  end

  def edit
  end

  def update
    ManagerEventTitle.find_by(event_name: @event.event_name, id: current_manager.id).destroy
    if @event.update_attributes(event_params)
      ManagerEventTitle.create!(event_name: @event.event_name, id: current_manager.id, note: params[:event][:note])
      flash[:success] = "#{@event.event_name}の情報を更新しました"
      if signed_in?
        redirect_to events_url(current_manager)
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    if @event.destroy
      if ManagerEventTitle.find_by(event_name: @event.event_name, id: current_manager.id).present?
        ManagerEventTitle.find_by(event_name: @event.event_name, id: current_manager.id).destroy
      end
      flash[:success] = "#{@event.event_name}を削除しました"
      redirect_to events_url(current_manager)
    end
  end
  
  private

    def event_params
      params.require(:event).permit(:id, :event_name, :event_type, :note, :date, :id)
    end
    
    def set_event
      @event = ManagerEvent.find(params[:id])
    end
end
