class Submanager::Settings::SubmanagerEventTitlesController < ApplicationController
  before_action :authenticate_submanager!
  before_action :not_current_submanager_return_login!

  def new
    @default_submanager_event_titles = current_submanager.submanager_event_titles.order(:event_name).order(created_at: "DESC")
    @event_titles = current_submanager.submanager_event_titles.order(:event_name).order(created_at: "DESC")
  end

  def create
    if current_submanager.submanager_event_titles.create(default_submanager_event_titles_params)
      @default_submanager_event_titles = current_submanager.submanager_event_titles.order(:event_name).order(created_at: "DESC")
      @event_title = current_submanager.submanager_event_titles.last
      respond_to do |format|
        format.js
      end
    else
    end
  end

  def update
    @submanager_event_title = SubmanagerEventTitle.find(params[:id])
    @submanager_event_titles = SubmanagerEventTitle.where(event_name: @submanager_event_title.event_name)
    @submanager_event_titles.each { |submanager_event_title| submanager_event_title.update(default_submanager_event_titles_params) }
    @submanager_event_title = SubmanagerEventTitle.find(params[:id])
    @default_submanager_event_titles = current_submanager.submanager_event_titles.order(:event_name).order(created_at: "DESC")
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @submanager_event_title = SubmanagerEventTitle.find(params[:id])
    @submanager_event_titles = SubmanagerEventTitle.where(event_name: @submanager_event_title.event_name)
    @submanager_event_titles.each { |submanager_event_title| submanager_event_title.destroy }
    flash[:success] = "イベント：#{@submanager_event_title.event_name}を削除しました"
    redirect_to new_submanager_settings_submanager_event_title_url(current_submanager)
  end

  private

    def default_submanager_event_titles_params
      params.require(:submanager_event_title).permit(:id,:event_name, :note)
    end
end
