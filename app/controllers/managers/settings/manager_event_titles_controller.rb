class Managers::Settings::ManagerEventTitlesController < ApplicationController
  before_action :authenticate_manager!
  before_action :not_current_return_login!
  
  def new
    @default_event_titles = current_manager.event_titles.order(:event_name).order(created_at: "DESC")
    @event_titles = current_manager.event_titles.order(:event_name).order(created_at: "DESC")
  end
  
  def create
    if current_manager.event_titles.create(default_event_titles_params)
      @default_event_titles = current_manager.event_titles.order(:event_name).order(created_at: "DESC")
      @event_title = current_manager.event_titles.last
      respond_to do |format|
        format.js
      end
    else
    end
  end
  
  def update
    @event_title = ManagerEventTitle.find(params[:id])
    @event_titles = ManagerEventTitle.where("event_name = ?", @event_title.event_name)
    @event_titles.each { |event_title| event_title.update(default_event_titles_params) }
    @event_title = ManagerEventTitle.find(params[:id])
    @default_event_titles = current_manager.event_titles.order(:event_name).order(created_at: "DESC")
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @event_title = ManagerEventTitle.find(params[:id])
    @event_titles = ManagerEventTitle.where("event_name = ?", @event_title.event_name)
    @event_titles.each { |event_title| event_title.destroy }
    flash[:success] = "イベント：#{@event_title.event_name}を削除しました"
    redirect_to new_settings_event_title_url(current_manager)
  end
  
  private
    
    def default_event_titles_params
      params.require(:event_title).permit(:id,:event_name, :note)
    end
end
