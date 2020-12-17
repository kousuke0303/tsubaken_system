class Employees::Matters::ImagesController < ApplicationController
  layout "image_layout"
  
  before_action :set_image, only: [:edit, :update, :destroy]
  before_action :current_matter

  def new
    @image = Image.new
  end

  def create
    @image = current_matter.images.new(image_params)
    if @image.save
      if admin_signed_in?
        @image.update(admin_id: current_admin.id)
      elsif manager_signed_in?
        @image.update(manager_id: current_manager.id)
      elsif staff_signed_in?
        @image.update(staff_id: current_staff.id)
      elsif external_staff_signed_in?
        @image.update(external_staff_id: current_external_staff.id)
      end
      flash[:success] = "写真を作成しました"
      redirect_to employees_matter_images_url(current_matter, @image)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @images = current_matter.images.select { |image| image.images.attached? }
  end
  
  def edit
  end
  
  def update
    if @image.update(image_content_and_shooted_on_params)
      flash[:success] = "写真を編集しました。"
      redirect_to employees_matter_images_url(current_matter, @image)
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    @image.destroy
    redirect_to employees_matter_images_url(current_matter, @image)
  end
  
  private
    def image_params
      params.require(:image).permit(:content, :shooted_on, :images, :matter_id)
    end
    
    def image_content_and_shooted_on_params
      params.require(:image).permit(:content, :shooted_on)
    end
    
    def set_image
      @image = Image.find(params[:id])
    end
end
