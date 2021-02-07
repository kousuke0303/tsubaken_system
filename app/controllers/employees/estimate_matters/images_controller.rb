class Employees::EstimateMatters::ImagesController < Employees::EmployeesController
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
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @certificates = current_estimate_matter.certificates.where(default: true)
    @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.images.attached? }
  end
  
  def edit
  end
  
  def update
    if @image.update(image_content_and_shooted_on_params)
      flash[:success] = "写真を編集しました。"
      redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    @image.destroy
    flash[:success] = "写真を削除しました。"
    redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
  end
  
  def save_for_band_image
    # ActiveRecord::Base.transaction do
      params[:estimate_matter][:images].each.with_index(1) do |params_image, index|
        # 画像を取り込んでフォルダに格納
        temporary_storage_for_image(params_image["images"], index)
        # 新規テーブル作成・保存
        image_model = current_estimate_matter.images.new(author: params_image["author"],
                                                         content: params_image["content"],
                                                         shooted_on: params_image["shooted_on"],
                                                         default_file_path: params_image["images"])
        image_model.images.attach(io: File.open(@file_path), 
                                  filename: @file_name,
                                  content_type: "image/jpeg")
        image_model.save!
        # ファイル削除
        File.delete(@file_path)
      end
      @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.images.attached? }
    # end
  # rescue
    # @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.images.attached? }
  end
  
  private
    def image_params
      params.require(:image).permit(:content, :shooted_on, :images, :estimate_matter_id)
    end
    
    def image_content_and_shooted_on_params
      params.require(:image).permit(:content, :shooted_on)
    end
    
    def set_image
      @image = Image.find(params[:id])
    end
    
    def temporary_storage_for_image(params_url, index)
      url = open(params_url)
      @file_name = params_url
      @file_path = Rails.root.join('public', 'temporary_storage', "#{current_estimate_matter.id}_#{index}.jpg")
      file = open(@file_path, "wb")
      file.write(url.read)
    end
    
end
