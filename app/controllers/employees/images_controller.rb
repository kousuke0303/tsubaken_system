class Employees::ImagesController < ApplicationController
  before_action :set_image, only: [:index, :show, :edit, :update, :destroy]
  before_action :current_matter

  def new
    @image = current_matter.images.build
  end

  def create
    @image = Image.create(image_params)
    if @image.save
      redirect_to employees_matter_image_url(current_matter, @image)
    else
      render :new
    end 
  end

  def show
    @images = Image.all
  end

  def edit
  end
  
  def destroy
    @image.destroy
    redirect_to employees_matter_image_url(current_matter, @image)
  end

  def update
    if params[:image][:image_ids]
      params[:image][:image_ids].each do |image_id|
        image = @image.images.find(image_id)
        image.purge
      end
    end
    if @image.destroy
      flash[:success] = "削除しました"
      respond_to do |format|
        format.js
      end
    else
      render :edit
    end
  end
  
  private
    def set_image
      @image = Image.with_attached_images.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:content, :shooted_on, images: [])
    end
end
