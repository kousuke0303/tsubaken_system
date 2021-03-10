class Employees::EstimateMatters::ImagesController < Employees::EmployeesController
  before_action :other_tab_display, only: :index
  before_action :set_image, only: [:edit, :update, :destroy]
  before_action :current_estimate_matter

  def new
    @image = Image.new
  end

  def create
    @image = current_estimate_matter.images.new(image_params)
    if @image.save
      @image.update("#{login_user.auth}_id".to_sym => login_user.id)
      flash[:success] = "写真を作成しました"
      redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
    end
  end

  def index
    @certificates = current_estimate_matter.certificates.where(default: true)
    @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.image.attached? }
  end
  
  def edit
  end
  
  def update
    if @image.update(image_content_and_shooted_on_params)
      flash[:success] = "写真を編集しました。"
      redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
    end
  end
  
  def destroy
    @image.destroy
    flash[:success] = "写真を削除しました。"
    redirect_to employees_estimate_matter_images_url(current_estimate_matter, @image)
  end
  
  def save_for_band_image
    ActiveRecord::Base.transaction do
      params[:estimate_matter][:images].each.with_index(1) do |params_image, index|
        # 画像を取り込んでフォルダに格納
        temporary_storage_for_image(params_image["image"], index, current_estimate_matter)
        # 新規テーブル作成・保存
        image_model = current_estimate_matter.images.new(author: params[:estimate_matter][:author],
                                                         content: params[:estimate_matter][:content],
                                                         shooted_on: params[:estimate_matter][:shooted_on],
                                                         default_file_path: params_image["image"])
        image_model.image.attach(io: File.open(@file_path), 
                                  filename: @file_name,
                                  content_type: "image/jpeg")
        image_model.save!
        # ファイル��除
        File.delete(@file_path)
      end
      @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.image.attached? }
      search_image(current_estimate_matter.band_connection.band_key)
      flash.now[:success] = "BAND画像を取り込みました"
    end
  rescue
    @images = current_estimate_matter.images.order(shooted_on: "DESC").select { |image| image.images.attached? }
  end
  
  private
    def image_params
      params.require(:image).permit(:content, :shooted_on, :image, :estimate_matter_id)
    end
    
    def image_content_and_shooted_on_params
      params.require(:image).permit(:content, :shooted_on)
    end
    
    def set_image
      @image = Image.find(params[:id])
    end
    
end
