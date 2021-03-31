class Employees::Matters::ImagesController < Employees::EmployeesController
  before_action :other_tab_display, only: :index
  before_action :set_image, only: [:edit, :update, :destroy]
  before_action :set_matter

  def new
    @image = Image.new
  end

  def create
    @image = @matter.images.new(image_params)
    if @image.save
      @image.update("#{login_user.auth}_id".to_sym => login_user.id)
      flash[:success] = "写真を作成しました"
      redirect_to employees_matter_images_url(@matter, @image)
    end
  end

  def index
    @images = @matter.images.order(shooted_on: "DESC").select { |image| image.image.attached? }
  end
  
  def edit
  end
  
  def update
    if @image.update(image_content_and_shooted_on_params)
      flash[:success] = "写真を編集しました。"
      redirect_to employees_matter_images_url(@matter, @image)
    end
  end
  
  def destroy
    @image.destroy
    redirect_to employees_matter_images_url(@matter, @image)
  end
  
  def save_for_band_image
    ActiveRecord::Base.transaction do
      params[:matter][:images].each.with_index(1) do |params_image, index|
        # 画像を取り込んでフォルダに格納
        temporary_storage_for_image(params_image["image"], index, @matter)
        # 新規テーブル作成・保存
        image_model = @matter.images.new(author: params[:matter][:author],
                                                        content: params[:matter][:content],
                                                        shooted_on: params[:matter][:shooted_on],
                                                        default_file_path: params_image["image"])
        image_model.image.attach(io: File.open(@file_path), filename: @file_name, content_type: "image/jpeg")
        image_model.save!
        File.delete(@file_path) # ファイル削除
      end
      @images = @matter.images.order(shooted_on: "DESC").select { |image| image.image.attached? }
      search_image(@matter.band_connection.band_key)
      flash.now[:success] = "BAND画像を取り込みました。"
    end
  rescue
    @images = @matter.images.order(shooted_on: "DESC").select { |image| image.images.attached? }
  end
  
  private
    def image_params
      params.require(:image).permit(:content, :shooted_on, :image, :matter_id)
    end
    
    def image_content_and_shooted_on_params
      params.require(:image).permit(:content, :shooted_on)
    end
    
    def set_image
      @image = Image.find(params[:id])
    end
end
