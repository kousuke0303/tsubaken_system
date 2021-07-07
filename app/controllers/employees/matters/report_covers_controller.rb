class Employees::Matters::ReportCoversController < Employees::EmployeesController
  before_action :set_matter_by_matter_id
  before_action ->{can_access_only_of_member(@matter)}
  before_action :set_publishers, only: [:new, :edit]
  before_action :set_report_cover, only: [:edit, :update, :destroy]

  def new
    @report_cover = @matter.build_report_cover
    @images = @matter.images.where(report_cover_list: true)
  end

  def create
    @report_cover = @matter.build_report_cover(report_cover_params)    
    @report_cover.save ? @responce = "success" : @responce = "false"
    set_images_of_report_cover
  end

  def edit
    @images = @matter.images.where(report_cover_list: true)
  end

  def update
    matter_of_report_cover_params
    @report_cover.update(report_cover_params) && @matter.update(started_on: @started_on, finished_on: @finished_on) ? @responce = "success" : @responce = "false"
    set_images_of_report_cover
  end

  def destroy
    @report_cover.destroy ? @responce = "success" : @responce = "false"
    @report_cover = @matter.report_cover
  end

  private
  def set_report_cover
    @report_cover = ReportCover.find(params[:id])
  end

  def report_cover_params
    params.require(:report_cover).permit(:title, :publisher_id, :created_on, :img_1_id, :img_2_id, :img_3_id, :img_4_id)
  end

  def matter_of_report_cover_params
    @started_on = params["report_cover"]["matter_attributes"]["started_on"]
    @finished_on = params["report_cover"]["matter_attributes"]["finished_on"]
  end
end
