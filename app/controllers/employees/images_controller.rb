class Employees::ImagesController < ApplicationController
  layout "image_layout"
  
  before_action :set_images, only: [:index, :edit]
  before_action :current_matter

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to employees_matter_images_url(current_matter, @image)
    else
      render :new
    end 
  end

  def index
  end

  def edit
    @image = Image.find(params[:id])
    if params[:image_ids]
      params[:image_ids].each do |image_id|
        image = @image.images.find(image_id)
        image.purge
      end
    end

    @image.update_attributes(image_edit_params)
  end
  
  private
    def set_images
      @images = Image.all.order('shooted_on DESC')
    end
    
    def image_params
      params.require(:image).permit(:content, :shooted_on, images: [])
    end

    def image_edit_params
      params.permit(:content, :shooted_on, images: [])
    end
end
