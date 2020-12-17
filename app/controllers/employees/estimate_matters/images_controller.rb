class Employees::EstimateMatters::ImagesController < ApplicationController
  layout "image_layout"
  
  before_action :set_image, only: [:edit, :update, :destroy]
  before_action :current_estimate_matter

  def new
    @image = Image.new
  end

  def create
    @image = current_estimate_matter.images.new(image_params)
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
      redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
    else
      flash[:success] = "写真の作成に失敗しました"
      redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
    end
  end

  def index
    @images = current_estimate_matter.images.select { |image| image.images.attached? }
    @messages = current_estimate_matter.messages.select { |message| message.photo.attached? }
  end
  
  def edit
    
  end
  
  def update
    if @image.update(image_params)
      flash[:success] = "写真を編集しました。"
      redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
    else
      flash[:danger] = "写真の編集に失敗しました。"
      redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
    end
  end
  
  def destroy
    @image.destroy
    flash[:success] = "写真を削除しました。"
    redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
  end
  
  private
    def image_params
      params.require(:image).permit(:content, :shooted_on, :images, :estimate_matter_id)
    end
    
    def set_image
      @image = Image.find(params[:id])
    end
end
