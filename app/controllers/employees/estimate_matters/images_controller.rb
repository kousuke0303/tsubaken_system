class Employees::EstimateMatters::ImagesController < ApplicationController
  layout "image_layout"
  
  before_action :set_image, only: [:edit, :update, :destroy]
  before_action :current_estimate_matter

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      @image.update(estimate_matter_id: params[:estimate_matter_id])
      flash[:success] = "作成しました"
      redirect_to employees_estimate_matter_images_path(current_estimate_matter, @image)
    else
      render :new
    end 
  end

  def index
    @images = Image.all.order('shooted_on DESC')
  end
  
  def edit
    
  end
  
  def update
    @image.update(image_params)
    redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
  end
  
  def destroy
    @image.destroy
    redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
  end
  
  private
    def image_params
      params.require(:image).permit(:content, :shooted_on, :images)
    end
    
    def set_image
      @image = Image.find(params[:id])
    end
end
