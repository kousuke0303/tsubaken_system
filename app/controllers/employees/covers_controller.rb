class Employees::CoversController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_publishers, only: [:new, :edit]
  
  def new
    @cover = @estimate_matter.build_cover
    @image = Image.find(params[:image_id])
    @covers = Cover.where(default: true)
  end
  
  def create
    @cover = @estimate_matter.build_cover(covers_params)
    @cover.save ? @responce = "success" : @responce = "failure"
    @cover_image = @estimate_matter.images.find_by(cover_list: true)
  end
  
  def edit
    @cover = Cover.find(params[:id])
    @image = @cover.image
    @covers = Cover.where(default: true)
  end
  
  def update
    @cover = Cover.find(params[:id])
    @cover.update(covers_params) ? @responce = "success" : @responce = "failure"
    @cover_image = @estimate_matter.images.find_by(cover_list: true)
  end
  
  def destroy
    @destroy_cover = Cover.find(params[:id])
    @destroy_cover.destroy
    @cover = @estimate_matter.build_cover
    @cover_image = @estimate_matter.images.find_by(cover_list: true)
  end
  
  private
    def covers_params
      params.require(:cover).permit(:publisher_id, :title, :content, :image_id)
    end
end
