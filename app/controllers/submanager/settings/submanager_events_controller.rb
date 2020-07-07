class Submanager::Settings::SubmanagerEventsController < ApplicationController
  before_action :set_submanager_event, only: [:edit, :update, :destroy]

  def create
    @submanager_event = SubmanagerEvent.new(submanager_event_params)
    if @submanager_event.save
      SubmanagerEventTitle.create!(event_name: @submanager_event.event_name, submanager_id: current_submanager.id, note: params[:submanager_event][:note])
      flash[:success] = "#{@submanager_event.event_name}を登録しました"
      redirect_to submanager_events_url(current_submanager)
    else
      redirect_to submanager_events_url(current_submanager)
    end
  end

  def edit
  end

  def update
    SubmanagerEventTitle.find_by(event_name: @submanager_event.event_name, submanager_id: current_submanager.id).destroy
    if @submanager_event.update_attributes(submanager_event_params)
      SubmanagerEventTitle.create!(event_name: @submanager_event.event_name, submanager_id: current_submanager.id, note: params[:submanager_event][:note])
      flash[:success] = "#{@submanager_event.event_name}の情報を更新しました"
      if submanager_signed_in?
        redirect_to submanager_events_url(current_submanager)
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    if @submanager_event.destroy
      if SubmanagerEventTitle.find_by(event_name: @submanager_event.event_name, submanager_id: current_submanager.id).present?
        SubmanagerEventTitle.find_by(event_name: @submanager_event.event_name, submanager_id: current_submanager.id).destroy
      end
      flash[:success] = "#{@submanager_event.event_name}を削除しました"
      redirect_to submanager_events_url(current_submanager)
    end
  end

  private

    def submanager_event_params
      params.require(:submanager_event).permit(:id, :event_name, :event_type, :note, :date, :submanager_id)
    end

    def set_submanager_event
      @submanager_event = SubmanagerEvent.find(params[:id])
    end

end