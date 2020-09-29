class Managers::Settings::ManagerEventTitlesController < ApplicationController
  before_action :authenticate_manager!
  before_action :not_current_manager_return_login!
  
  def new
    @default_manager_event_titles = current_manager.manager_event_titles.order(:event_name).order(created_at: "DESC")
    @event_titles = current_manager.manager_event_titles.order(:event_name).order(created_at: "DESC")
  end
  
  def create
    if current_manager.manager_event_titles.create(default_manager_event_titles_params)
      @default_manager_event_titles = current_manager.manager_event_titles.order(:event_name).order(created_at: "DESC")
      @event_title = current_manager.manager_event_titles.last
      respond_to do |format|
        format.js
      end
    else
    end
  end
  
  def update
    @manager_event_title = ManagerEventTitle.find(params[:id])
    @manager_event_titles = ManagerEventTitle.where(event_name: @manager_event_title.event_name)
    @manager_event_titles.each { |manager_event_title| manager_event_title.update(default_manager_event_titles_params) }
    @manager_event_title = ManagerEventTitle.find(params[:id])
    @default_manager_event_titles = current_manager.manager_event_titles.order(:event_name).order(created_at: "DESC")
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @manager_event_title = ManagerEventTitle.find(params[:id])
    @manager_event_titles = ManagerEventTitle.where(event_name: @manager_event_title.event_name)
    @manager_event_titles.each { |manager_event_title| manager_event_title.destroy }
    flash[:success] = "イベント：#{@manager_event_title.event_name}を削除しました"
    redirect_to new_manager_settings_manager_event_title_url(current_manager)
  end
  
  private
    
    def default_manager_event_titles_params
      params.require(:manager_event_title).permit(:id,:event_name, :note)
    end
end
