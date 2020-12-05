class Staffs::Settings::StaffEventTitlesController < ApplicationController
  before_action :authenticate_staff!
  # before_action :not_current_staff_return_login!

  def new
    @default_staff_event_titles = current_staff.staff_event_titles.order(:event_name).order(created_at: "DESC")
    @event_titles = current_staff.staff_event_titles.order(:event_name).order(created_at: "DESC")
  end

  def create
    if current_staff.staff_event_titles.create(default_staff_event_titles_params)
      @default_staff_event_titles = current_staff.staff_event_titles.order(:event_name).order(created_at: "DESC")
      @event_title = current_staff.staff_event_titles.last
      respond_to do |format|
        format.js
      end
    else
    end
  end

  def update
    @staff_event_title = StaffEventTitle.find(params[:id])
    @staff_event_titles = StaffEventTitle.where("event_name = ?", @staff_event_title.event_name)
    @staff_event_titles.each { |staff_event_title| staff_event_title.update(default_staff_event_titles_params) }
    @staff_event_title = StaffEventTitle.find(params[:id])
    @default_staff_event_titles = current_staff.staff_event_titles.order(:event_name).order(created_at: "DESC")
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @staff_event_title = StaffEventTitle.find(params[:id])
    @staff_event_titles = StaffEventTitle.where("event_name = ?", @staff_event_title.event_name)
    @staff_event_titles.each { |staff_event_title| staff_event_title.destroy }
    flash[:success] = "イベント：#{@staff_event_title.event_name}を削除しました"
    redirect_to new_staff_settings_staff_event_title_url(current_staff)
  end

  private

    def default_staff_event_titles_params
      params.require(:staff_event_title).permit(:id,:event_name, :note)
    end
end
